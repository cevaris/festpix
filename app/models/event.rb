class Event < ActiveRecord::Base
  belongs_to :user
  has_many :photo_sessions, :dependent => :destroy
  # accepts_nested_attributes_for :event_images, allow destroy => true
  # validates_attachment_content_type :event_images, :content_type => /\Aimage\/.*\Z/

end
