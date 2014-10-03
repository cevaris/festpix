class HomeController < ApplicationController
  def index
  end

  def render_500
    render :status => 500, text: ''
  end
  def render_timeout
    sleep 50
    render :status => 200, text: ''
  end
end
