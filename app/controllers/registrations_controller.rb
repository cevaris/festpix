class RegistrationsController < Devise::RegistrationsController

  before_action :user_new_params, only:[:create]
  

  def update
    @user = User.find(current_user.id)

    successfully_updated = if needs_password?(@user, params)
      @user.update_with_password(devise_parameter_sanitizer.sanitize(:account_update))
    else
      params[:user].delete(:current_password)
      @user.update_without_password(devise_parameter_sanitizer.sanitize(:account_update))
    end

    if successfully_updated
      set_flash_message :notice, :updated
      sign_in @user, :bypass => true
      redirect_to after_update_path_for(@user)
    else
      render "edit"
    end
  end


  # # POST /events
  # # POST /events.json
  # def create
  #   @user = User.new(user_new_params)
  #   Rails.logger.info "After #{params[:user]}"
  #   Rails.logger.info "Cleaned Params #{user_new_params.inspect}"
  #   update_devise_parameter_sanitizer

  #   respond_to do |format|
  #     if @user.save
  #       sign_in @user
  #       Rails.logger.info "#{@user.inspect}"
  #       format.html { redirect_to @user, notice: 'Welcome to FestPics.' }
  #       format.json { render action: 'show', status: :created, location: @user }
  #     else
  #       format.html { render action: 'new' }
  #       format.json { render json: @user.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # def create
    
  #   @user = User.new(args)
  #   if @user.save
  #     sign_in @user
  #     Rails.logger.info "#{@user.inspect}"
  #     flash[:notice] = "Welcome to FestPics"
  #     redirect_to @user
  #   else
  #     render :action => :new
  #   end
  # end


  private

  def needs_password?(user, params)
    user.email != params[:user][:email] || params[:user][:password].present?
  end

  def user_new_params
    Rails.logger.info "Before #{params[:user]}"
    params.require(:user).permit(:kind, :email, :password, :password_confirmation)
    # params.require(:p).permit(:kind, :email, :password, :password_confirmation)
    # params.require(:user).permit!
    # params.require(:user).permit(:kind, :email, :password, :password_confirmation, :fake_ds)

  end


  # def new_sanitized_params
  #   devise_parameter_sanitizer.for(:sign_up).push(:kind)
  # end

  # def update_sanitized_params
  #   devise_parameter_sanitizer.for(:account_update).push(:kind)
  #   devise_parameter_sanitizer.for(:sign_up).push(:kind)
  # end
end