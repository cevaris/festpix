require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "create user creation" do
    test_email = "me@email.com"
    u = User.new(:email => test_email, :password => "somesecret")
    assert u.save!
    assert User.find_by_email(test_email)
  end
end
