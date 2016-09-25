require 'byebug'

require_relative '../../lib/connections/controller_base.rb'

class SailsController < ControllerBase
  protect_from_forgery
  def login!(user)
    session['session_token'] = user.reset_session_token
  end

  def logout!
    current_user.reset_session_token
    session['session_token'] = nil
  end

  def current_user
    @current_user ||= User.where(session_token: session['session_token']).first
  end


end
