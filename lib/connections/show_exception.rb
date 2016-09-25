require 'erb'
require 'byebug'
class ShowExceptions
  attr_reader :app
  def initialize(app)
    @app = app
  end

  def call(env)

    begin
      @app.call(env)
    rescue Exception => e
      # byebug
      render_exception(e)
    end
  end

  private

  def render_exception(e)
    # byebug
    template_to_render = "lib/connections/templates/rescue.html.erb"
    html_content = File.read(template_to_render)
    erb_content_evaluated = ERB.new(html_content).result(binding)

    ["500",{'Content-type' => 'text/html'}, [erb_content_evaluated] ]

  end

end
