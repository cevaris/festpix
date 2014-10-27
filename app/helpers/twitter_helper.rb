module TwitterHelper
  def twitter_client(creds)
    puts "Found Creds #{creds.inspect}"
    Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["CONSUMER_KEY"]
      config.consumer_secret     = ENV["CONSUMER_SECRET"]
      config.access_token        = creds[:oauth_token]
      config.access_token_secret = creds[:oauth_token_secret]
    end
  end

  def download_image(url)
    image = Tempfile.new('twitter.oauth')
    File.open(image, "wb") do |f| 
      f.write HTTParty.get(url).parsed_response
      puts "Downloaded Image to #{image.path}"
    end
    image
  end

  def post_message(text, creds)
    puts "Got message #{text}"
    client = twitter_client(creds)
    client.update(text).inspect
  end

  def post_image(url, creds)
    puts "Got URL #{url}"

    client = twitter_client(creds)
    image = download_image(url)
    
    client.update_with_media("Photo post #{Time.now.utc.to_i}", image).inspect
  end
end