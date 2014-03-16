module PhotoSessionsHelper

  def send_sms(data)
    twilio = Rails.application.config.TWILIO

    data[:to]
    data[:link]
    data[:media_url]

    account_sid = twilio[:sid]
    auth_token  = twilio[:auth]
    @client     = Twilio::REST::Client.new account_sid, auth_token
     
    message = @client.account.messages.create(
      body: "Your images are ready, click the link to see them. #{data[:link]}",
      to: data[:to],
      from: twilio[:phone],
      media_url: data[:media_url])
    puts message.to

  end
end
