require 'securerandom'


class Photo < ActiveRecord::Base
  belongs_to :photo_session

  has_attached_file :image, 
    :styles => {
      thumb: '100x100#', 
      square: '200x200#', 
      medium: '500x500>',
      large: '800x800>',
      xlarge: '1600x1400>' }

  validates_attachment_content_type :image, :content_type => %w(image/jpeg image/jpg image/png)


  before_save :default_values
  def default_values
    self.slug ||= SecureRandom.hex[0..10]
  end

end
