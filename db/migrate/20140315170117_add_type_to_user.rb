class AddTypeToUser < ActiveRecord::Migration
  def change
    add_column :users, :kind, :string

    User.all.each do |user|
      user.kind = User::TYPES[:admin]
      user.save
    end

  end
end