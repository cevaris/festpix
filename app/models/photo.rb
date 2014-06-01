require 'securerandom'


class Photo < ActiveRecord::Base


  belongs_to :photo_session

  STYLES={
    thumb: '100x100#', 
    square: '200x200#', 
    medium: '500x500>',
    large: '800x800>',
    xlarge: { 
      :geometry => '1600x1400>', 
      :watermark_path => "#{Rails.root}/public/watermarks/festpix.png"},
      :transparancy => '30'
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

  validates_attachment_content_type :image, :content_type => %w(image/jpeg image/jpg image/png)


  def url
    Rails.application.routes.url_helpers.photo_short_url(self, host: ENV['SHORT_URL'])
  end

  def short_url
    Rails.application.routes.url_helpers.photo_short_url(self, host: ENV['SHORT_URL'])[7..-1]
  end

  before_save :default_values
  def default_values
    # self.slug ||= SecureRandom.hex[0..10]
    self.slug = loop do
      token = SecureRandom.hex[0..3]
      break token unless Photo.exists?(slug: token)
    end
  end

  def to_param
    self.slug
  end 

end
