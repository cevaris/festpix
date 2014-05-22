require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Rq
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
    config.time_zone = 'Mountain Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.autoload_paths += %W(#{config.root}/lib)
    config.scoped_views = true
    config.assets.precompile << Proc.new { |path|
      if path =~ /\.(eot|svg|ttf|woff)\z/
        true
      end
    }

    config.paperclip_defaults = {
      :storage => :s3,
      :s3_credentials => {
        :bucket => ENV['S3_BUCKET_NAME'],
        :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
        :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
      }
    }

    config.TWILIO = {
      sid: ENV['TW_SID'],
      auth: ENV['TW_AUTH'],
      phone: ENV['TW_PHONE']
    }

    config.action_mailer.smtp_settings = {
      :address              => "host11.registrar-servers.com",
      :port                 => 465,
      :user_name            => 'photos@festpix.com',
      :password             => '9l4V2DT7h!dB',
      :authentication       => 'plain',
      :enable_starttls_auto => true  
    }


  end
end
