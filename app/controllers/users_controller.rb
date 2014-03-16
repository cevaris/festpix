class UsersController < ApplicationController

  def index
    redirect_to root_path    
  end
  
  def show
    @user = User.find(params[:id])
    @sessions = PhotoSession.tagged_with(@user.id.to_s, :any => true)
    
    begin
      friend_emails = @sessions.collect {|p| p.email_list }.flatten.uniq.select {|email| email if email != @user.email}
      @friends = User.find(:all, {email:  friend_emails}, limit: 4)
    rescue ActiveRecord::RecordNotFound
      @friends = [] 
    end

    
  end

end
 