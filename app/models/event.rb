require 'securerandom'

class Event < ActiveRecord::Base

  belongs_to :customer
  belongs_to :event_feature,  :dependent => :destroy
  has_many   :photo_sessions, :dependent => :destroy

  has_attached_file :logo, styles: { 
    thumb:  '100x100#',
    medium: '250x250>',
    large:  '500x500>'
  }

  has_attached_file :watermark, styles: { 
    thumb:  '100x100#',
    medium: '250x250>',
    large:  '500x500>'
  }
  
  validates_attachment_content_type :logo, :content_type => %w(image/jpeg image/jpg image/png)
  validates_attachment_content_type :watermark, :content_type => %w(image/jpeg image/jpg image/png)
  validates_uniqueness_of :slug
  
  validates_length_of :sms_text,      :minimum => 0, :maximum => 100, :allow_blank => true
  validates_length_of :facebook_text, :minimum => 0, :maximum => 250, :allow_blank => true
  validates_length_of :twitter_text,  :minimum => 0, :maximum => 130, :allow_blank => true
  validates_length_of :button_text,   :minimum => 0, :maximum => 20,  :allow_blank => true

  validates_length_of :slug, :minimum => 3, :maximum => 40, :allow_blank => false
  validates_format_of :slug, with: /\A(^[\w]+)$\Z/, message: 'Invalid Characters in URL Route/Name. Possible characters [A-Z, a-b, 0-9].', multiline: false

  accepts_nested_attributes_for :event_feature
  

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

    self.event_feature ||= EventFeature.create
    # self.event_feature ||= EventFeature.find_or_create_by_event_id(self.id)
  end

  def shares
    Rails.cache.fetch("event_shares_#{self.id}", expires_in: 10.minutes) do
      s = PhotoSession.where(event_id: self.id).pluck(:twitter_shares, :facebook_shares, :instagram_shares, :custom_button_shares, :downloads).transpose.map {|a| a.inject(:+)}
      {twitter: s[0], facebook: s[1], instagram: s[2], custom_button: s[3], downloads: s[4]}
    end
  end

  def total_sessions
    Rails.cache.fetch("event_total_photo_session_#{self.id}", expires_in: 10.minutes) do
      PhotoSession.where(event_id: self.id).count
    end
  end

  def opened_sessions
    Rails.cache.fetch("event_total_opened_#{self.id}", expires_in: 10.minutes) do
      PhotoSession.where(event_id: self.id).map {|ps| ps.is_opened? ? 1 : 0 }.sum
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
