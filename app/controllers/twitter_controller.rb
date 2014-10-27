class TwitterController < ApplicationController
  include TwitterHelper 

  def auth
    redirect_to '/auth/twitter'
  end

  def failure
  end
  
  def callback
    session[:tc] = {
      oauth_token:        request.env['omniauth.auth']['credentials']['token'],
      oauth_token_secret: request.env['omniauth.auth']['credentials']['secret']
    }.to_json

    redirect_to_back
  end

  def post
    
    @photo = Photo.find params[:photo_id]
    resposne = post_image(params[:text], @photo, JSON.parse(cookies[:tc], {:symbolize_names => true}))
    render json: resposne.to_json

  end

end
