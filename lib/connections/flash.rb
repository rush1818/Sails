require 'json'

class Flash
  attr_accessor :now, :flash

  def initialize(req)
    cookie = req.cookies["_rails_lite_app_flash"]
    if cookie
      @deserialized_cookie = JSON.parse(cookie)
    else
      @deserialized_cookie = {}
    end
    @now = {}
  end

  def [](key)
    @deserialized_cookie[key] || @now[key]
  end

  def []=(key, val)
    @deserialized_cookie[key] = val
  end

  def store_flash(res)
    cookie_to_save = { path: "/", value: @deserialized_cookie.to_json }
    res.set_cookie("_rails_lite_app_flash", cookie_to_save)
  end


end
