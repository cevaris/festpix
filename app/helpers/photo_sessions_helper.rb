module PhotoSessionsHelper
  # include ActionView::Helpers::TextHelper
  # include ActionView::Helpers::UrlHelper

  def queue_sms(photo_session)
    phone_list = photo_session.phone_list.split
    # Return if no phone #'s are given/found
    return unless phone_list
      

    data = {}
    phone_list.each do |phone|
      data[:to] = phone
      # data[:link] = link_to(photo_session_path(photo_session), photo_session_path(photo_session))
      # photo = photo_session.photos.last
      # data[:media_url] = link_to(photo.image.url(:medium), photo.image.url(:medium))

      # data[:link] = "<a href='#{photo_session_url(photo_session)}'>#{photo_session_url(photo_session)}</a>"
      data[:link] = photo_session_url(photo_session)
      # photo = photo_session.photos.last
      # data[:media_url] = photo.image.url(:medium)

      # Rails.logger.info "Sending SMS #{data.inspect}"
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
      body: "Your images are ready, click the link to see them. #{data[:link]}",
      to: data[:to],
      from: twilio[:phone]#,
      # media_url: data[:media_url]
    )
    Rails.logger.info "Sent SMS #{@client.inspect}"

  end
end
