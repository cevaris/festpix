class PhotoSessionMailer < ActionMailer::Base
  default from: "festpixmedia@gmail.com"

  def photo_session_email (photo_session)

    email_list = photo_session.email_list
    Rails.logger.info "Email List #{email_list.inspect}"
    # Return if no emails are given/found
    return true if email_list.nil? or email_list.count == 0
    Rails.logger.info "Email Valid #{email_list.inspect}"
      
    # data = {}
    # phone_list.each do |phone|
    #   data[:to] = phone
    #   data[:link] = photo_session_url(photo_session)
    #   # photo = photo_session.photos.last
    #   data[:media_url] = photo.image.url(:medium)
    #   send_sms(data)
    # end

    @photo_session = photo_session
    # @message = "FestPix! Your images are ready, click the link to see them. #{@photo_session}"
    email_list.each do |email|
      mail(
        :from => "photos@festpix.com",
        :to => email,
        :subject => "FestPix! Your images are ready").deliver!
    end

    return true
    
  end
end
