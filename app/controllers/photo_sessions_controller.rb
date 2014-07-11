class PhotoSessionsController < ApplicationController
  include PhotoSessionsHelper
  include MailChimpHelper

  protect_from_forgery :except => [:create]
  before_action :set_photo_session, only: [:show, :edit, :update, :destroy]
  before_action :require_session, only: [:index, :claim]


  # GET /photo_sessions
  # GET /photo_sessions.json
  def index

    # if params[:email_list]
    #   emails = PhotoSession.tagged_with(params[:email_list].split, :match_all => true)
    # else
    #   emails = []
    # end
    
    # if params[:phone_list]
    #   phones = PhotoSession.tagged_with(params[:phone_list].split, :match_all => true)
    # else
    #   phones = []
    # end

    # @photo_sessions = emails | phones
    redirect_to action: "new"
  end

  # GET /photo_sessions/1/claim
  def claim

    # check if emails match
    # user is already logged in if here
    # 

    @user = current_user
    @photo_session = PhotoSession.find params[:photo_session_id]

    email_list = @photo_session.email_list
    phone_list = @photo_session.phone_list

    if email_list.include? @user.email or phone_list.count > 0
      # Do it, do it!!!
      @photo_session.attendee_list.add(@user.id.to_s)
      @photo_session.save
      return redirect_to current_user, notice: 'Photo Session was successfully claimed.'
    else
      return redirect_to current_user, error: 'You do not have permissions to claim'
    end
    
  end


  def email_new
    render 'email/new'
  end

  # # GET /photo_session/1/email
  # def email_create

  #   @photo_session = PhotoSession.find params[:photo_session_id]
  #   Rails.logger.info params

  #   return render nothing: true, status: 500 unless params.has_key? 'email'

  #   Rails.logger.info params
  #   list_id = get_mailing_list()

  #   if params[:subscribe] == 'on' and list_id and subscribe_to_list( list_id, params[:email] )

  #     @photo_session.email_list.add( params[:email] )
  #     @photo_session.save

  #     redirect_to @photo_session
  #   else
  #     redirect_to photo_session_url(@photo_session)
  #   end


  # end


  # GET /photo_sessions/1
  # GET /photo_sessions/1.json
  def show
    if current_user
      @claimed = @photo_session.attendee_list.include? current_user.id.to_s
    else
      @claimed = false
    end       

    Rails.logger.info "#{@photo_session.slug} is opened yet? #{@photo_session.opened_at}"
    unless @photo_session.opened_at
      @photo_session.opened_at = DateTime.now
      @photo_session.save!
    end
    Rails.logger.info "Errors #{@photo_session.errors.inspect}"
  end

  def admin_show
    @photo_sessions = PhotoSession.paginate(:page => params[:page], :per_page => 20).order('id DESC')
    # @photo_sessions = PhotoSession.all
  end


  # GET /photo_sessions/new
  def new
    @photo_session = PhotoSession.new
    3.times { @photo_session.photos.build }
  end

  # GET /photo_sessions/1/edit
  def edit
  end

  # POST /activities
  # POST /activities.json
  def create

    Rails.logger.info params.inspect

    @photo_session = PhotoSession.new(photo_session_params)
    # @photo_session.photographer = current_user

    if params[:photo_session].has_key?(:phone_list)
      @photo_session.phone_list = params[:photo_session][:phone_list]
    end
    if params[:photo_session].has_key?(:email_list)
      @photo_session.email_list = params[:photo_session][:email_list]
    end
    # if params.has_key?(:photo_session) and params[:photo_session].has_key?(:emails)
    #   @photo_session.email_list = params[:photo_session][:emails]
    # end


    respond_to do |format|
      if @photo_session.save
        
        queue_sms(@photo_session)
        PhotoSessionMailer.photo_session_email(@photo_session).deliver

        flash.notice = "Photo Session was successfully created. #{view_context.link_to 'Click here to View.', photo_session_path(@photo_session) }".html_safe
        format.html { redirect_to action: "new" }
        format.json { render json: { result: "sucess", path: @photo_session.short_url } }
      else
        # Delete images post invalidation
        @photo_session.photos.map(&:destroy)
        @photo_session.photos = []
        3.times { @photo_session.photos.build }

        format.html { render action: "new" }
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
      begin
        !!Integer(params[:id])
        # raise ArgumentError if Integer(params[:id])
        @photo_session = PhotoSession.find(params[:id])
        redirect_to @photo_session
      rescue ArgumentError, TypeError, ActiveRecord::RecordNotFound
        @photo_session = PhotoSession.find_by_slug(params[:id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def photo_session_params
      #params.require(:photo_session).permit(:name, :photo_user_id, :event_id, :phones, :emails, :photos_attributes)
      params.require(:photo_session).permit!
    end
end
