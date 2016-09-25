require 'rack'
require_relative './lib/all_files_to_load'

require_relative './config/routes.rb'


app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  ROUTER_CONFIG.run(req, res)
  res.finish
end

Rack::Server.start(
 app: app,
 Port: 3000
)
