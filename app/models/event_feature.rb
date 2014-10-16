class EventFeature < ActiveRecord::Base

  before_save :default_values
  def default_values
    self.facebook_share_button  ||= true
    self.twitter_share_button   ||= true
    self.instagram_share_button ||= false
    self.download_button        ||= true
    self.download_clicked_image ||= false

    true
  end

end
