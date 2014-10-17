class EventFeature < ActiveRecord::Base

  # before_save :default_values
  after_initialize :default_values
  def default_values
    if self.new_record?
      # self.facebook_share_button  = true
      # self.twitter_share_button   = true
      # self.instagram_share_button = false
      # self.download_clicked_image = false
      # self.download_button        = true
    end
  end


  def facebook_share_button_active?
    self.facebook_share_button ? 'active' : ''
  end
  def facebook_share_button_inactive?
    self.facebook_share_button ? '' : 'active'
  end

  def twitter_share_button_active?
    self.twitter_share_button ? 'active' : ''
  end
  def twitter_share_button_inactive?
    self.twitter_share_button ? '' : 'active'
  end

  def instagram_share_button_active?
    self.instagram_share_button ? 'active' : ''
  end
  def instagram_share_button_inactive?
    self.instagram_share_button ? '' : 'active'
  end

  def download_button_active?
    self.download_button ? 'active' : ''
  end
  def download_button_inactive?
    self.download_button ? '' : 'active'
  end

  def download_clicked_image_active?
    self.download_clicked_image ? 'active' : ''
  end
  def download_clicked_image_inactive?
    self.download_clicked_image ? '' : 'active'
  end

  


end
