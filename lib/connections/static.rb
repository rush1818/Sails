require 'byebug'
class Static
  attr_reader :app

  def initialize(app)
    @app = app
  end

  FILE_EXTENSIONS = {
    '.txt' => 'text/plain',
    '.jpg' => 'image/jpeg',
    '.png' => 'image/png',
    '.zip' => 'application/zip'
  }

  def call(env)
    req = Rack::Request.new(env)
    res = Rack::Response.new
    requested_path = req.path[1..-1]
    requested_file_ext = File.extname(requested_path)

    begin
      res['Content-type'] = FILE_EXTENSIONS[requested_file_ext]
      output = File.read(requested_path)
      res.write(output)
    rescue
      res.status = 404
      res.write("Not Found")
    end
    res.finish
  end
end
