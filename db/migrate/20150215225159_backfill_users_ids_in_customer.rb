class BackfillUsersIdsInCustomer < ActiveRecord::Migration
  def self.up
    # User.all.each do |u|
    #   c = u.customer
    #   c.user_id = u.id
    #   success = c.save
    #   puts u.id, u.customer_id, u.customer.id, success, c.errors.messages.inspect
    # end
    Customer.all.each do |c|
      u = User.find_by(customer_id: c.id)
      print "#{c.name}: "
      if u
        c.user = u
        success = c.save if u
        puts u.id , u.customer_id, c.id, success, c.errors.messages.inspect
      end
    end
  end

  def self.down
  end
end
