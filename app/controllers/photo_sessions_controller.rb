class PhotoSessionsController < ApplicationController
  before_action :set_photo_session, only: [:show, :edit, :update, :destroy]

  # GET /photo_sessions
  # GET /photo_sessions.json
  def index
    @photo_sessions = PhotoSession.all
  end

  # GET /photo_sessions
  # GET /photo_sessions.json
  def search

    # @photo_sessions = PhotoSession.find_by 
  end

  # GET /photo_sessions/1
  # GET /photo_sessions/1.json
  def show
  end

  # GET /photo_sessions/new
  def new
    @photo_session = PhotoSession.new
    5.times { @photo_session.photos.build }
    # @photo_session.email_list = 'cevaris@gmail.com,chek@yahoo.com'
  end

  # GET /photo_sessions/1/edit
  def edit
  end

  # POST /photo_sessions
  # POST /photo_sessions.json
  def create
    @photo_session = PhotoSession.new(photo_session_params)

    respond_to do |format|
      if @photo_session.save
        format.html { redirect_to @photo_session, notice: 'Photo session was successfully created.' }
        format.json { render action: 'show', status: :created, location: @photo_session }
      else
        format.html { render action: 'new' }
        format.json { render json: @photo_session.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /photo_sessions/1
  # PATCH/PUT /photo_sessions/1.json
  def update
    respond_to do |format|
      if @photo_session.update(photo_session_params)
        format.html { redirect_to @photo_session, notice: 'Photo session was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @photo_session.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /photo_sessions/1
  # DELETE /photo_sessions/1.json
  def destroy
    @photo_session.destroy
    respond_to do |format|
      format.html { redirect_to photo_sessions_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_photo_session
      @photo_session = PhotoSession.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def photo_session_params
      params.require(:photo_session).permit(:name, :photo_user_id, :event_id)
    end
end
