class UsersController < ApplicationController

  def index
    unless current_user
      redirect_to root_path
    else
      redirect_to current_user    
    end
    
  end
  
  def show
    @user = User.find_by_slug(params[:id])
    @sessions = PhotoSession.tagged_with(@user.phone_number, :any => true)
    
    # begin
    #   friend_emails = @sessions.collect {|p| p.email_list }.flatten.uniq.select {|email| email if email != @user.email}
    #   @friends = User.find(:all, {email:  friend_emails}, limit: 4)
    # rescue ActiveRecord::RecordNotFound
    #   @friends = [] 
    # end

    
  end

end
 