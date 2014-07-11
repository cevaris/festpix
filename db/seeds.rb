# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.find_by_email('festpix@gmail.com').delete
User.find_or_create_by_email!(
  email: 'festpix@gmail.com',
  password: ENV['ADMIN_PASS'],
  phone_number: '5594516126'
)