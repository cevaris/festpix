require 'test_helper'

class RegistrationsControllerTest < ActionController::TestCase
  
  
  test "user assosciations" do
    @request.env["devise.mapping"] = Devise.mappings[:user]

    assert_difference('User.count') do
      test_email = 'me@email.com'
      test_name = 'custom_name'

      post :create, user: {
             email: test_email,
             password: 'somesecret',
             password_confirmation: 'somesecret',
             customer_attributes: { name: test_name }
           }

      u = assigns(:user)
      assert (not u.customer.nil?)
      assert (not u.customer.events.empty?)
      assert (not u.customer.events.first.nil?)
      assert (not u.customer.events.first.watermark.nil?)
    end
    
  end
end
