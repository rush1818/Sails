require 'rack'
require_relative './lib/connections/logger.rb'
require_relative './lib/all_files_to_load'

require_relative './config/routes.rb'

app_code = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  ROUTER_CONFIG.run(req, res)
  res.finish
end


app = Rack::Builder.new do
  use LoggerMiddleware
  run app_code
end.to_app

Rack::Server.start(
 app: app,
 Port: 3000
)
