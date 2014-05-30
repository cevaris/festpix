class PhotoSession < ActiveRecord::Base
  include ActionView::Helpers::UrlHelper

  acts_as_taggable_on :emails
  acts_as_taggable_on :phones
  acts_as_taggable_on :attendees

  has_many :photos
  belongs_to :event
  belongs_to :photographer, class_name: 'User', foreign_key: 'photo_user_id'
  accepts_nested_attributes_for :photos, :allow_destroy => true

  validate :phone_list_format

  def phone_list_format
    Rails.logger.info "Phones #{self.phone_list.inspect}"

    if self.phone_list.empty? or self.phone_list == ['']
      errors.add(:phone_list, "is missing.")
    elsif self.phone_list
      phone_list.each do |phone_number|
        errors.add(:phone_list, "has invalid phone format.") unless phone_number =~ User::PHONE_FORMAT
      end
    end
  end


  before_save :default_values
  def default_values
    self.slug ||= SecureRandom.hex[0..10]
  end

  def to_param
    self.slug
  end 

end
