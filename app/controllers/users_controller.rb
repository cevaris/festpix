class UsersController < ApplicationController
  load_and_authorize_resource :find_by => :slug

  def index
    unless current_user
      redirect_to root_path
    else
      redirect_to current_user    
    end
    
  end
  
  def show
    # @user = User.find_by_slug(params[:id])
    # @user = current_user
    # @sessions = PhotoSession.tagged_with(@user.phone_number, :any => true).limit(12).order('id DESC')
    # TODO: View users photo sessions or events
    @sessions = []     
  end

end
 