
class MoveUserIdToCustomer < ActiveRecord::Migration
  def self.up
    add_column :customers, :user_id, :integer
    # Backfill user_id into Customer
    Customer.all.each do |c|
      # Find User
      u = User.find_by(customer_id: c.id)
      if u
        # If this customer has a user,
        # update the user_id field
        c.user = u
        c.save
      end
    end
  end

  def self.down
    remove_column :customers, :user_id
  end
  
end
