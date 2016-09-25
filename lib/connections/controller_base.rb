require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'
require_relative './flash'
require 'byebug'

class ControllerBase
  attr_reader :req, :res, :params

  def initialize(req, res, route_params = {})
    @req = req
    @res = res
    @params = route_params.merge(req.params)
    @@require_auth ||= false
  end

  def already_built_response?
    @already_built_response
  end

  def redirect_to(url)
    raise "Double Render" if already_built_response?
    @res.set_header('Location', url)
    # @res.set_header('status', 302)
    @res.status = 302
    @already_built_response = true
    self.session.store_session(@res)
    self.flash.store_flash(@res)
  end

  def render_content(content, content_type)
    raise "Double Render" if already_built_response?
    @already_built_response = true
    @res["Content-Type"] = content_type
    @res.write(content)
    self.session.store_session(@res)
    self.flash.store_flash(@res)
  end


  def render(template_name)
    class_name = self.class.name.underscore
    template_to_render = "app/views/#{class_name}/#{template_name}.html.erb"
    html_content = File.read(template_to_render)
    erb_content_evaluated = ERB.new(html_content).result(binding)
    render_content(erb_content_evaluated, 'text/html')
  end

  def session
    @session ||= Session.new(@req)
  end

  def flash
    @flash ||= Flash.new(@req)
  end

  def invoke_action(name)
    if @@require_auth && @req.request_method != "GET"
      self.check_authenticity_token
    else
      self.form_authenticity_token
    end

    if @req.request_method == 'POST'  # handle delete requests
      if @req.params['_method'] && @req.params['_method'] == 'delete'
        self.send(:destroy)
        render(:index) unless already_built_response?
        return
      end
    end
    self.send(name)
    render(name) unless already_built_response?
  end

  def form_authenticity_token
    @auth_token ||= SecureRandom.urlsafe_base64(32)
    @res.set_cookie('authenticity_token', value: @auth_token, path: '/')
    @auth_token
  end

  def check_authenticity_token
    cookie = @req.cookies["authenticity_token"]
    unless cookie && cookie == params["authenticity_token"]
      raise "Invalid authenticity token"
    end
  end

  def self.protect_from_forgery
    @@require_auth = true
  end
end
