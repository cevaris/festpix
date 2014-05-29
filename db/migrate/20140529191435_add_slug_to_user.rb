class AddSlugToUser < ActiveRecord::Migration
  def change
    add_column :users, :slug, :string
    
    # Create slug for previous photos
    User.all.each do |user|
      user.slug = SecureRandom.hex[0..10]
      user.save
    end

    # Add index for to photo slugs
    add_index :users, :slug
  end
end
