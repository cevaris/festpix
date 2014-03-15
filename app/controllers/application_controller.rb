class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :update_devise_parameter_sanitizer, if: :devise_controller?



  def update_devise_parameter_sanitizer
    # devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:kind, :email, :password, :password_confirmation) }
    devise_parameter_sanitizer.for(:sign_up).push(:kind)
    devise_parameter_sanitizer.for(:account_update).push(:kind)
    Rails.logger.info "Devise Params #{devise_parameter_sanitizer.for(:sign_up)}"
    # devise_parameter_sanitizer.for(:sign_up)
    # params.require(:user).permit(:email, :password, :password_confirmation, :kind) if params.has_key? :user
  end

  def require_session
    unless current_user
      flash[:error] = 'You must be logged in to view this page.'  
      redirect_to new_user_registration_path
    end
  end 

end
