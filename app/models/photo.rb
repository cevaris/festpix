require 'securerandom'


class Photo < ActiveRecord::Base
  belongs_to :photo_session

  has_attached_file :image, 
    :processors => [:watermark],
    # :convert_options => {
    #   :xlarge => {
    #     :transparancy => '15'
    #   }
    # },
    :styles => {
      thumb: '100x100#', 
      square: '200x200#', 
      medium: '500x500>',
      large: '800x800>',
      xlarge: { 
        :geometry => '1600x1400>', 
        :watermark_path => "#{Rails.root}/public/watermarks/festpix.png"},
        :transparancy => '30'
    }

  validates_attachment_content_type :image, :content_type => %w(image/jpeg image/jpg image/png)


  before_save :default_values
  def default_values
    self.slug ||= SecureRandom.hex[0..10]
  end

  def to_param
    self.slug
  end 

end
