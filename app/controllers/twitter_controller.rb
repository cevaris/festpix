class TwitterController < ApplicationController

  def auth
    redirect_to '/auth/twitter'
  end

  def failure
  end
  
  def callback
    cookies[:tc] = {
      oauth_token:        request.env['omniauth.auth']['credentials']['token'],
      oauth_token_secret: request.env['omniauth.auth']['credentials']['secret']
    }.to_json

    redirect_to_back
  end

  def create
    # Create Image or Text
  end

end
