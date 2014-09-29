class AddRoleToUsers < ActiveRecord::Migration

  def self.up
    add_column :users, :role, :string

    User.all.each do |user|
      user.role ||= User::ROLES[:customer]
      user.save
    end
  end

  def self.down
    remove_column :users, :role
  end

end
