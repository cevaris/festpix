class EventFeature < ActiveRecord::Base

  before_validation :default_values
  def default_values
    self.facebook_share_button = true if self.facebook_share_button.nil?
    self.twitter_share_button = true if self.twitter_share_button.nil?
    self.instagram_share_button = false if self.instagram_share_button.nil?
    self.download_button = true if self.download_button.nil?
    self.download_clicked_image = false if self.download_clicked_image.nil?
    self.is_watermark_or_frame = true if self.is_watermark_or_frame.nil?
    true
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

  def is_watermark?
    self.is_watermark_or_frame ? 'active' : ''
  end
  def is_frame?
    self.is_watermark_or_frame ? '' : 'active'
  end


end
