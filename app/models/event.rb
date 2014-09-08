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
  
  validates_length_of :sms_text,      :minimum => 0, :maximum => 100, :allow_blank => true
  validates_length_of :facebook_text, :minimum => 0, :maximum => 100, :allow_blank => true
  validates_length_of :twitter_text,  :minimum => 0, :maximum => 100, :allow_blank => true

  validates_length_of :slug, :minimum => 3, :maximum => 40, :allow_blank => false
  validates_format_of :slug, with: /\A(^[\w]+)$\Z/, message: 'Invalid Characters in URL Route/Name. Possible characters [A-Z, a-b, 0-9].', multiline: false
  

  #############################
  ## Logic to disable change of slug
  # attr_readonly :slug
  # validate :validate_slug_change
  # def validate_slug_change
  #   self.errors.add(:base, "Url/Name Route '#{self.slug_was}' cannot be changed") if self.slug_changed?
  # end
  #############################


  before_save :default_values
  def default_values
    # Remove any new lines
    self.sms_text      = self.sms_text.squish      if self.sms_text
    self.twitter_text  = self.twitter_text.squish  if self.twitter_text
    self.facebook_text = self.facebook_text.squish if self.facebook_text

    self.logo = File.new("#{Rails.root}/public/watermarks/festpix.png") unless self.logo.exists?
  end

  def shares
    Rails.cache.fetch("customer_shares", expires_in: 10.minutes) do
      PhotoSession.where(event_id: self.id).pluck(:twitter_shares, :facebook_shares, :instagram_shares).transpose.map {|a| a.inject(:+)}
    end
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
