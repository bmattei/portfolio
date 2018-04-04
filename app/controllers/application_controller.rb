class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def access_denied(exception)
    redirect_to root_url, alert: exception.message + " " + exception.action.to_s + " " + exception.subject.to_s
  end
end
