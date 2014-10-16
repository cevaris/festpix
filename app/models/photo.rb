require 'securerandom'


class Photo < ActiveRecord::Base


  belongs_to :photo_session, inverse_of: :photos

  ## Another hopeful
  # http://stackoverflow.com/questions/14305018/ruby-on-rails-paperclip-and-dynamic-parameters?rq=1

  STYLES = lambda { |attachment| {
      thumb: '100x100#', 
      square: '200x200#', 
      medium: {
        :geometry => '640x640#',
        :watermark_path => attachment.instance.watermark_path,
      },
      large: '800x800>',
      xlarge: {
        :geometry => '1600x1400>',
        :watermark_path => attachment.instance.watermark_path,
      }
    }
  }
  
  if ENV['BACKGROUND_PROCESSING']=='true'
    Rails.logger.info "Background Processing Enabled: #{ENV['BACKGROUND_PROCESSING']}"
    has_attached_file :image, 
    :processors => [:watermark],
    :styles => STYLES, 
    :only_process => [:square, :xlarge]

    self.process_in_background :image, :only_process => [:thumb, :medium, :large]
  else
    Rails.logger.info "Background Processing Disabled: #{ENV['BACKGROUND_PROCESSING']}"
    has_attached_file :image, 
    :processors => [:watermark],
    :styles => STYLES
  end

  validates :photo_session, presence: true
  validates_attachment_content_type :image, :content_type => %w(image/jpeg image/jpg image/png)
  validates_attachment_presence :image


  def url
    Rails.application.routes.url_helpers.photo_short_url(self, host: ENV['SHORT_URL'])
  end

  def short_url
    Rails.application.routes.url_helpers.photo_short_url(self, host: ENV['SHORT_URL'])[7..-1]
  end

  # # For Photo Session
  # def customer_url
  #   Rails.application.routes.url_helpers.event_photo_session_url(self.photo_session.event.slug, self.photo_session.slug, host: ENV['SHORT_URL'])
  # end
  # For Photo
  def customer_url
    Rails.application.routes.url_helpers.event_photo_url(self.photo_session.event.slug, self.slug, host: ENV['SHORT_URL'])
  end

  def watermark_path
    # self.photo_session.event.watermark.url(:medium)
    self.photo_session.event.watermark.url(:medium)
  end

  before_save :default_values
  def default_values
    # self.slug ||= SecureRandom.hex[0..10]
    self.slug ||= loop do
      token = SecureRandom.hex[0..3]
      break token unless Photo.exists?(slug: token)
    end
  end

  def to_param
    self.slug
  end 

end
