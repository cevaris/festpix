# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user='admin@festpix.com'
User.find_or_initialize_by_email(user).update_attributes({
  email: user,
  password: ENV['ADMIN_PASS'],
  phone_number: '5594516126',
  role: User::ROLES[:super_admin]
})


## Add default Festpix Event/Customer to all previous photo sessions
fp_customer = 'Festpix'
puts Customer.find_or_initialize_by_name(fp_customer).update_attributes({
  slug:        'festpix',
  color_one:   '#1b1b24',
  color_two:   '#333333',
  color_three: '#428bca',
})

puts Event.find_or_initialize_by_name(fp_customer).update_attributes({
  slug:          'festpix',
  logo:          File.new("#{Rails.root}/public/watermarks/festpix.png"),
  sms_text:      'FestPix! Your images are ready, click the link to see them.',
  facebook_url:  'https://www.facebook.com/festpix',
  facebook_text: 'Shared via',
  twitter_url:   'https://twitter.com/festpix',
  twitter_text:  'Shared via',
  customer_id:   Customer.find_by_name(fp_customer).id
})