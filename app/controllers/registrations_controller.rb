class RegistrationsController < Devise::RegistrationsController  

  # def new
  #   super
  #   resource.build_customer
  #   Rails.logger.info resource.customer.inspect
  # end

  
  def update
    @user = User.find(current_user.id)

    successfully_updated = if needs_password?(@user, params)
      @user.update_with_password(devise_parameter_sanitizer.sanitize(:account_update))
    else
      params[:user].delete(:current_password)
      @user.update_without_password(devise_parameter_sanitizer.sanitize(:account_update))
    end

    if successfully_updated
      @user.save
      set_flash_message :notice, :updated
      sign_in @user, :bypass => true
      redirect_to @user
    else
      render "edit"
    end
  end

  private

  def needs_password?(user, params)
    user.email != params[:user][:email] || params[:user][:password].present?
  end


end
