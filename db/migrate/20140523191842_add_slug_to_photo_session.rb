class AddSlugToPhotoSession < ActiveRecord::Migration
  def change
    add_column :photo_sessions, :slug, :string
    
    # Create slug for previous photos
    PhotoSession.all.each do |photo|
      photo.slug = SecureRandom.hex[0..10]
      photo.save
    end

    # Add index for to photo slugs
    add_index :photo_sessions, :slug
  end
end
