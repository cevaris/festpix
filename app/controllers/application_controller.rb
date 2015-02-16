class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :update_devise_parameter_sanitizer, if: :devise_controller?


  after_filter :store_location

  def store_location
    # store last url as long as it isn't a /users path
    session[:referer] = request.referer #request.fullpath unless request.fullpath =~ /\/users/
  end

  def after_sign_in_path_for(resource)
    user_path(resource) || session[:referer] || root_path
  end
  def after_sign_up_path_for(resource)
    user_path(resource) || session[:referer] || root_path
  end

  def after_sign_out_path_for(resource_or_scope)
    session[:tc] = nil
    cookies[:tc] = nil
    root_path
  end

  def update_devise_parameter_sanitizer
    devise_parameter_sanitizer.for(:sign_up).push(
      :phone_number,:avatar,:slug,:role,customer_attributes: [:name])
    devise_parameter_sanitizer.for(:account_update).push(
      :phone_number,:slug,:avatar,:role,customer_attributes: [:name])
  end

  def redirect_to_back
    redirect_to(session[:referer] || :back)
  rescue ActionController::RedirectBackError
    redirect_to root_path
  end

  def require_session
    unless current_user
      flash[:error] = 'Please log in'
      redirect_to user_session_path
    end
  end 

  before_filter do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end
  rescue_from CanCan::AccessDenied do |exception|  
    Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}"
    flash[:error] = "Access denied!"  
    redirect_to_back
  end 

end
