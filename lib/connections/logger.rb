require 'rack'

class LoggerMiddleware
  attr_reader :app

  def initialize(app)
    p "Initializing logger"
    @app = app
  end

  def call(env)
    write_log(env)
    app.call(env)
  end

  private

  def write_log(env)
    req = Rack::Request.new(env)
    log_text = <<-LOG
    Time: #{Time.now}
    Path: #{req.path}
    Method: #{req.request_method}
    Params: #{req.params}
    IP: #{req.ip}
    User Agent: #{req.user_agent}
    LOG

    p "*" * 10
    p log_text
    p "*" * 10
  end
end
