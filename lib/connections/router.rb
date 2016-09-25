require 'byebug'
class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern = pattern
    @http_method = http_method

    @controller_class = controller_class
    @action_name = action_name
  end

  def matches?(req)
    return false unless req.request_method.downcase.to_sym == self.http_method

    return false unless self.pattern =~ req.path
    # => Note that pattern will be a Regexp, so you should use the match operator =~, not ==
    true
  end

  def run(req, res)
    matched_pattern = @pattern.match(req.path)
    all_keys = matched_pattern.names
    params = Hash.new()
    all_keys.each {|key| params[key] = matched_pattern[key]}
    # byebug
    self.controller_class.new(req, res, params).invoke_action(self.action_name)
  end
end

class Router
  attr_reader :routes

  def initialize
    @routes = []
  end


  def add_route(pattern, method, controller_class, action_name)
    new_route = Route.new(pattern, method, controller_class, action_name)
    @routes << new_route
  end

  def draw(&prc)
    self.instance_eval(&prc)
  end

  [:get, :post, :put, :delete].each do |http_method|
    define_method(http_method) do |pattern, controller_class, action_name|
      add_route(pattern, http_method, controller_class, action_name)
    end
  end

  def match(req)
    @routes.each do |route|
      return route if route.matches?(req)
    end
    nil
  end

  def run(req, res)
    matching_route = self.match(req)
    if matching_route.nil?
      res.status = 404
    else
      matching_route.run(req, res)
    end
  end
end
