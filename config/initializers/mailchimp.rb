# Gibbon.api_key = ENV['MAILCHIMP_API_KEY']
# Gibbon.timeout = 15
# # Gibbon.throws_exceptions = false
# Gibbon.throws_exceptions = true


Gibbon::API.api_key = ENV['MAILCHIMP_API_KEY']
Gibbon::API.timeout = 15
# Gibbon::API.throws_exceptions = true
Gibbon::API.throws_exceptions = false