class Event < ActiveRecord::Base
  has_many :event_images, :dependent => :destroy
  # accepts_nested_attributes_for :event_images, allow destroy => true
  # validates_attachment_content_type :event_images, :content_type => /\Aimage\/.*\Z/

end
