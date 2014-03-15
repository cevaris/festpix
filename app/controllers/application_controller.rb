class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def require_session
    unless current_user
      flash[:error] = 'You must be logged in to view this page.'  
      redirect_to new_user_registration_path
    end
  end 

end
