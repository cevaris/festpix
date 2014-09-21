class PhotoSessionsController < ApplicationController
  include PhotoSessionsHelper
  include MailChimpHelper

  protect_from_forgery :except => [:create]
  before_action :set_event_cookie
  before_action :set_photo_session, only: [:show, :edit, :update, :destroy, :social_share]
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
    if current_user
      @photo_sessions = PhotoSession.paginate(:page => params[:page], :per_page => 20).order('id DESC')
      render 'admin_show'
    else
      redirect_to action: "new"
    end
    
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

  def social_share

    # Make sure this key exists
    params[:social_type] ||= ''

    case params[:social_type].strip.downcase
    when 'facebook'
      @photo_session.facebook_shares  = @photo_session.facebook_shares + 1
    when 'twitter'
      @photo_session.twitter_shares   = @photo_session.twitter_shares  + 1
    when 'instagram'
      @photo_session.instagram_shares = @photo_session.instagram_shares + 1
    else
      # Do nothing, did not match any social type
    end

    respond_to do |format|
      if @photo_session.save
        format.json { head :ok }
      else
        format.json { render :json => @photo_session.errors, :status => :unprocessable_entity }
      end
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

    # Rails.logger.info "#{@photo_session.slug} is opened yet? #{@photo_session.opened_at}"
    unless @photo_session.opened_at
      @photo_session.opened_at = DateTime.now
      @photo_session.save!
    end
        
    if params.include? :event_url
      @event = Event.find_by_slug(params[:event_url])
      Rails.logger.info "Loading Custom Event #{@event}"
    else
      Rails.logger.info "Loading Default Event"
      @event = false
    end

  end

  def admin_show
    @photo_sessions = PhotoSession.paginate(:page => params[:page], :per_page => 20).order('id DESC')
    # @photo_sessions = PhotoSession.all
  end


  # GET /photo_sessions/new
  def new
    

    Rails.logger.info "Cached Event #{@event}"

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

    ###############################################################
    ## Hack to get working photo uploads
    ps_params = photo_session_params
    ## Extract photos to be saved later
    defer_photos_params = ps_params['photos_attributes']
    ## Remove the photos from rest of the params
    ps_params.delete 'photos_attributes'
    ## Create a photo session without the photos (to be saved later)
    Rails.logger.info "PS params #{@ps_params.inspect}"
    @photo_session = PhotoSession.new(ps_params)
    Rails.logger.info "PS w/out Photos #{@photo_session.inspect}"
    ###############################################################

    # Drop cookie down to save event selection 
    if params[:photo_session].has_key?(:event_id)
      cookies[:event] = { value: @photo_session.event.id , :expires => 1.hour.from_now }
    end

    if params[:photo_session].has_key?(:phone_list)
      @photo_session.phone_list = params[:photo_session][:phone_list]
    end
    if params[:photo_session].has_key?(:email_list)
      @photo_session.email_list = params[:photo_session][:email_list]
    end
    # if params.has_key?(:photo_session) and params[:photo_session].has_key?(:emails)
    #   @photo_session.email_list = params[:photo_session][:emails]
    # end

    save_status = @photo_session.save
      
    if save_status
      if defer_photos_params.nil?
        @photo_session.errors.add(:base, 'Need to upload at least one photo') 
        save_status = false
      else
        ## For each deferred photo, assign a photo session id and save
        defer_photos_params.each do |i, file|
          photo = Photo.new
          photo.photo_session_id = @photo_session.id
          photo.image = file['image']
          save_status &= photo.save
        end
      end
    end

    respond_to do |format|

      if save_status
        
        queue_sms(@photo_session)
        # PhotoSessionMailer.photo_session_email(@photo_session).deliver

        response = {  result: "success", path: @photo_session.short_url,
            id: @photo_session.id.to_s, slug: @photo_session.slug, 
            event_id: @photo_session.event_id.to_s, event_slug: @photo_session.event.slug }

        Rails.logger.info "Response Message: #{response.inspect}"

        flash.notice = "Photo Session was successfully created. #{view_context.link_to 'Click here to View.', @photo_session.customer_url }".html_safe
        format.html { redirect_to action: "new" }
        format.json { render json: response }
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

    def set_event_cookie
      if cookies[:event]
        @event = Event.find(cookies[:event])
      else
        @event = Event.find_by_slug 'festpix'
      end
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_photo_session
      begin
        # !!Integer(params[:id])
        # raise ArgumentError if Integer(params[:id])
        @photo_session = PhotoSession.find_by_slug(params[:id])
        # @event = @photo_session.event
        # redirect_to @photo_session
      rescue ArgumentError, TypeError, ActiveRecord::RecordNotFound
        # PhotoSession.find(params[:id])
        @photo_session = PhotoSession.find(params[:id])
      end
      @event = @photo_session.event
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def photo_session_params
      #params.require(:photo_session).permit(:name, :photo_user_id, :event_id, :phones, :emails, :photos_attributes)
      params.require(:photo_session).permit!
    end
end
