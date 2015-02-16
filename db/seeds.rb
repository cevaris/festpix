# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

## Add default Festpix Event/Customer to all previous photo sessions
super_admin_email = 'admin@festpix.com'
fp_customer_name = 'Festpix'
admins = [
  'mark@festpix.com',
  'alex@festpix.com',
  'colton@festpix.com',
]

def create_admin(email, customer_name)
  puts email, User.find_or_initialize_by_email(email).update_attributes({
    email: email,
    password: ENV['ADMIN_PASS'],
    role: User::ROLES[:admin],
    customer_id: Customer.find_by_name(customer_name).id,
  })
end

puts Customer.find_or_initialize_by_name(fp_customer_name).update_attributes({
  color_one:   '#1b1b24',
  color_two:   '#333333',
  color_three: '#428bca',
})

puts super_admin_email, User.find_or_initialize_by_email(super_admin_email).update_attributes({
  email: super_admin_email,
  password: ENV['SUPER_ADMIN_PASS'],
  phone_number: '5594516126',
  role: User::ROLES[:super_admin],
  customer_id: Customer.find_by_name(fp_customer_name).id,
})

puts Event.find_or_initialize_by_name(fp_customer_name).update_attributes({
  name:          fp_customer_name,
  logo:          File.new("#{Rails.root}/public/watermarks/festpix.png"),
  sms_text:      'FestPix! Your images are ready, click the link to see them.',
  facebook_url:  'https://www.facebook.com/festpix',
  facebook_text: 'Shared via',
  twitter_url:   'https://twitter.com/festpix',
  twitter_text:  'Shared via',
  customer_id:   Customer.find_by_name(fp_customer_name).id,
})

admins.each {|a| create_admin(a, fp_customer_name)}

