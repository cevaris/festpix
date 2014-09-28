require 'securerandom'

class Customer < ActiveRecord::Base
   
    has_many :events, :dependent => :destroy

    # validates_uniqueness_of :name
    validates_length_of :name, :minimum => 3, :maximum => 30, :allow_blank => false
    validates_uniqueness_of :slug, message: 'URL Route/Name has already been taken.', multiline: false
    
    validates_length_of :slug, :minimum => 3, :maximum => 50, :allow_blank => false
    validates_format_of :slug, with: /\A(^[\w]+)$\Z/, message: 'Invalid Characters in URL Route/Name. Possible characters [A-Z, a-b, 0-9].', multiline: false

    before_save :default_values
    def default_values
      self.color_one   ||= '#1b1b24'
      self.color_two   ||= '#333333'
      self.color_three ||= '#428bca'
    end


    def shares
      Rails.cache.fetch("customer_shares_#{self.id}", expires_in: 10.minutes) do
        s = PhotoSession.where(event_id: self.events.ids).pluck(:twitter_shares, :facebook_shares, :instagram_shares).transpose.map {|a| a.inject(:+)}
        {twitter: s[0], facebook: s[1], instagram: s[2]}
      end
    end

    def total_sessions
      Rails.cache.fetch("customer_total_photo_session_#{self.id}", expires_in: 10.minutes) do
        PhotoSession.where(event_id: self.events.ids).count
      end
    end

    def opened_sessions
      Rails.cache.fetch("customer_total_opened_#{self.id}", expires_in: 10.minutes) do
        PhotoSession.where(event_id: self.events.ids).map {|ps| ps.is_opened? ? 1 : 0 }.sum
      end
    end

    def to_s
      self.name
    end

    def to_param
      self.slug
    end 

end
