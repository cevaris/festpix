class EventImagesController < ApplicationController
  before_action :require_session, only: [:new, :edit, :create]

  # GET /event_image/new
  def new
    @event_image = EventImage.new
  end

  # GET /event_image/1/edit
  def edit
  end

  # POST /event_image
  # POST /event_image.json
  def create
    @event_image = EventImage.new(event_images_params)

    # respond_to do |format|
    #   if @event_image.save
    #     format.html { redirect_to @event_image, notice: 'Event was successfully created.' }
    #     format.json { render action: 'show', status: :created, location: @event_image }
    #   else
    #     format.html { render action: 'new' }
    #     format.json { render json: @event_image.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  private 
    def event_params
      params.require(:event_images_params).permit(:user_id, :image)
    end

  
end
