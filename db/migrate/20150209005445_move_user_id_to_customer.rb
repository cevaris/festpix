
class MoveUserIdToCustomer < ActiveRecord::Migration
  def self.up
    add_column :customers, :user_id, :integer

    # Backfill user_id into Customer
    User.all.each do |u|
      c = Customer.find(u.customer_id)
      c.user_id = u.id
      c.save
    end
    Customer.where(user_id: nil).each do |c|
      c.user = User.find_by_email('admin@festpix.com')
      c.save
    end
  end

  def self.down
    remove_column :customers, :user_id
  end
  
end
