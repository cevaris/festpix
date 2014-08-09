class AddLogoAndUrlAndSlugToEvents < ActiveRecord::Migration

  def self.up
    remove_column  :events, :user_id
    add_column     :events, :customer_id, :integer

    add_attachment :events, :logo

    add_column     :events, :sms_text, :string
    
    add_column     :events, :facebook_url, :text
    add_column     :events, :facebook_text, :string

    add_column     :events, :twitter_url, :text
    add_column     :events, :twitter_text, :string

    add_column     :events, :slug, :string
    add_index      :events, :slug
  end

  def self.down
    add_column        :events, :user_id, :integer
    remove_column     :events, :customer_id
    
    remove_attachment :events, :logo

    remove_column     :events, :sms_text
    
    remove_column     :events, :facebook_url
    remove_column     :events, :facebook_text

    remove_column     :events, :twitter_url
    remove_column     :events, :twitter_text

    remove_index      :events, :slug
    remove_column     :events, :slug
  end
 
end
