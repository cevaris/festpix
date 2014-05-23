require 'securerandom'


class AddSlugToPhoto < ActiveRecord::Migration
  def change
    add_column :photos, :slug, :string
    
    # Create slug for previous photos
    Photo.all.each do |photo|
      photo.slug = SecureRandom.hex[0..10]
      photo.save
    end

    # Add index for to photo slugs
    add_index :photos, :slug

  end
end
