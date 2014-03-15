class EventImage < ActiveRecord::Base
  belongs_to :event

  has_attached_file :image, :styles => {
    thumb: '100x100#', 
    square: '200x200#', 
    medium: '500x500>',
    large: '700x700>' }



end
