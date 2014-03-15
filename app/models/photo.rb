class Photo < ActiveRecord::Base
  belongs_to :photo_session

  has_attached_file :image, :styles => {
    thumb: '100x100#', 
    square: '200x200#', 
    medium: '500x500>',
    large: '700x700>' }

  validates_attachment_content_type :image, :content_type => %w(image/jpeg image/jpg image/png)

end
