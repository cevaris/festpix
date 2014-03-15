class PhotoController < ApplicationController
  before_action :require_session, only: [:new, :edit, :create]

  # GET /event_image/new
  def new
    @photo = Photo.new
  end

  # GET /event_image/1/edit
  def edit
  end

  # POST /event_image
  # POST /event_image.json
  def create
    @photo = Photo.new(photo_params)

    respond_to do |format|
      if @photo.save
        format.html { redirect_to @photo, notice: 'Photo was successfully created.' }
        format.json { render action: 'show', status: :created, location: @photo }
      else
        format.html { render action: 'new' }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end

  end

  private 
    def photo_params
      params.require(:photo_params).permit(:user_id, :image)
    end
end
