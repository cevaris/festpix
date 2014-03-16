class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :update_devise_parameter_sanitizer, if: :devise_controller?



  def update_devise_parameter_sanitizer
    devise_parameter_sanitizer.for(:sign_up).push(:kind,:avatar)
    devise_parameter_sanitizer.for(:account_update).push(:kind,:avatar)
  end

  def require_session
    unless current_user
      flash[:error] = 'Please log in to claim these photos'  
      redirect_to user_session_path
    end
  end 

end
