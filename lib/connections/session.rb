require 'json'

class Session
  def initialize(req)
    @cookie_name = '_sails'
    @cookie = req.cookies["#{@cookie_name}"]
    if @cookie
      @deserialized_cookie = JSON.parse(@cookie)
    else
      @deserialized_cookie = {}
    end
  end

  def [](key)
    @deserialized_cookie[key]
  end

  def []=(key, val)
    @deserialized_cookie[key] = val
  end

  def store_session(res)
    cookie_to_save = { path: "/", value: @deserialized_cookie.to_json }
    res.set_cookie("#{@cookie_name}", cookie_to_save)
  end
end
