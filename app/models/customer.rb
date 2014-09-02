require 'securerandom'

class Customer < ActiveRecord::Base
   
    has_many :events, :dependent => :destroy

    validates_uniqueness_of :name
    validates_uniqueness_of :slug, message: 'URL Route/Name has already been taken.', multiline: false
    
    validates_length_of :slug, :minimum => 3, :maximum => 50, :allow_blank => false
    validates_format_of :slug, with: /\A(^[\w]+)$\Z/, message: 'Invalid Characters in URL Route/Name. Possible characters [A-Z, a-b, 0-9].', multiline: false

    before_save :default_values
    def default_values
      self.color_one   ||= '#1b1b24'
      self.color_two   ||= '#333333'
      self.color_three ||= '#428bca'
    end

    def to_s
      self.name
    end

    def to_param
      self.slug
    end 

end
