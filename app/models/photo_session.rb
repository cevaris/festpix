class PhotoSession < ActiveRecord::Base
  acts_as_taggable_on :emails
  acts_as_taggable_on :phones
  acts_as_taggable_on :attendees

  has_many :photos
  belongs_to :event
  belongs_to :photographer, class_name: 'User', foreign_key: 'photo_user_id'
  accepts_nested_attributes_for :photos, :allow_destroy => true


  before_save :default_values
  def default_values
    self.slug ||= SecureRandom.hex[0..10]
  end
  
end
