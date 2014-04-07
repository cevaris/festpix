module PhotoSessionsHelper

  def queue_sms(photo_session)
    
    phone_list = photo_session.phone_list
    Rails.logger.info "Phone List #{phone_list.inspect}"
    # Return if no phone #'s are given/found
    return true if phone_list.nil? or phone_list.count == 0
    Rails.logger.info "Found phones #{phone_list.inspect}"
      
    data = {}
    phone_list.each do |phone|
      data[:to] = phone
      data[:link] = photo_session_pics_url(photo_session)
      # photo = photo_session.photos.last
      # data[:media_url] = photo.image.url(:medium)
      send_sms(data)
    end

    return true
  end

  def send_sms(data)
    twilio = Rails.application.config.TWILIO

    # data[:to]
    # data[:link]
    # data[:media_url]

    account_sid = twilio[:sid]
    auth_token  = twilio[:auth]
    @client     = Twilio::REST::Client.new account_sid, auth_token
     
    message = @client.account.messages.create(
      body: "FestPix! Your images are ready, click the link to see them. #{data[:link]}",
      to: data[:to],
      from: twilio[:phone]
    )
    Rails.logger.info "Sent SMS #{@client.inspect}"

  end
end
