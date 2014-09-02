class ConvertSocialStringsToText < ActiveRecord::Migration
  def self.up
    change_column :events, :sms_text,      :text
    change_column :events, :facebook_text, :text
    change_column :events, :twitter_text,  :text
  end

  def self.down
    change_column :events, :sms_text,      :string
    change_column :events, :facebook_text, :string
    change_column :events, :twitter_text,  :string
  end
end
