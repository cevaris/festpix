class UsersController < ApplicationController
  
  def show
    @user = User.find(params[:id])
    @sessions = PhotoSession.tagged_with(@user.email, :any => true)
    
    begin
      Rails.logger.info "User Email #{@user.email}"
      friend_emails = @sessions.collect {|p| p.email_list }.flatten.uniq.select {|email| email if email != @user.email}
      Rails.logger.info "Friends #{friend_emails.inspect}"
      @friends = User.find_by(email:  friend_emails)
    rescue ActiveRecord::RecordNotFound
      @friends = [] 
    end

    Rails.logger.info "Friends #{@friends.inspect}"
    
  end

end
 