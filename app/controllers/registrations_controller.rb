class RegistrationsController < Devise::RegistrationsController  

  def create
    build_resource(sign_up_params)

    #################################################
    customer_saved = false
    customer = Customer.new(
      slug: params[:customer_slug],
      name: params[:customer_name],
      color_one:   '#1b1b24', color_two:   '#333333', color_three: '#428bca',
    )
    customer_saved = customer.save
    resource.errors[:base] += customer.errors[:base]
    resource.customer = Customer.find_by_slug(params[:customer_slug]) if customer_saved
    #################################################

    resource_saved = resource.save

    Rails.logger.info customer.inspect
    Rails.logger.info customer.errors.inspect
    Rails.logger.info customer_saved
    Rails.logger.info resource.inspect
    Rails.logger.info resource.errors.inspect
    Rails.logger.info resource_saved

    yield resource if block_given?
    if customer_saved and resource_saved
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      # clean_up_passwords resource
      respond_with resource
    end

  end


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