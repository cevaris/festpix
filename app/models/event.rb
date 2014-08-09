require 'securerandom'

class Event < ActiveRecord::Base

  belongs_to :customer
  has_many   :events
  has_many   :photo_sessions, :dependent => :destroy

  has_attached_file :logo, styles: { 
    thumb:  '100x100#',
    medium: '250x250>',
    large:  '500x500>'
  }
  
  validates_attachment_content_type :logo, :content_type => %w(image/jpeg image/jpg image/png)
  validates_uniqueness_of :slug
  validates_length_of :slug, :minimum => 3, :maximum => 40, :allow_blank => false
  validates_length_of :sms_text, :minimum => 0, :maximum => 100, :allow_blank => true

  before_save :default_values
  def default_values
    self.logo ||= File.new("#{Rails.root}/public/watermarks/festpix.png")
  end

  def festpix?
    self.slug == 'festpix'
  end

  def to_s
    "#{self.name}"
  end
  
  def to_param
    self.slug
  end  

end
