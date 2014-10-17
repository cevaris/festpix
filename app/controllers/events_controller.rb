class EventsController < ApplicationController

  load_and_authorize_resource :find_by => :slug
  # # before_action :set_event, only: [:show, :edit, :update, :destroy]
  # before_action :require_session, only: [:new, :edit, :update, :destroy]

  # GET /events
  # GET /events.json
  def index
    @events = Event.accessible_by(current_ability, :update)
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
    @event.event_feature = EventFeature.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)
    # @event.user = current_user

    respond_to do |format|
      if @event.save

        # Provide default watermark if not included
        # @event.logo = File.new("#{Rails.root}/public/watermarks/festpix.png") unless @event.logo.exists?
        @event.watermark = File.new("#{Rails.root}/public/watermarks/festpix.png") unless @event.watermark.exists?
        @event.save

        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render action: 'show', status: :created, location: @event }
      else
        format.html { render action: 'new' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      Rails.logger.info "Args #{event_params[:event_feature_attributes]}"
      if @event.update(event_params) and @event.event_feature.update(event_params[:event_feature_attributes])
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :no_content }
    end
  end

  def autocomplete
    @events = Event.order(:name).where("name ILIKE ?", "%#{params[:q]}%")
    respond_to do |format|
      format.json { 
        render json: @events.collect { |c| { id: c.id, text: c.name } } 
      }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    # def set_event
    #   @event = Event.find_by_slug(params[:id]) || Event.find(params[:id])
    # end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(
        :name, :slug, :description, :customer_id, :sms_text, 
        :logo, :watermark, 
        :facebook_url, :facebook_text, 
        :twitter_url, :twitter_text,
        :button_url, :button_text,
        event_feature_attributes: [:id, :facebook_share_button, :twitter_share_button, :instagram_share_button, :download_button, :download_clicked_image ])
      # params.require(:event).permit!
    end
end
