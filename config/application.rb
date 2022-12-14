require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module InstrumentchampPrototype
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths += %W(#{config.root}/lib/lists) # TODO: include all subdirectories in /lib
    config.autoload_paths += %W(#{config.root}/lib/lists/users) # TODO: include all subdirectories in /lib
    config.autoload_paths += %W(#{config.root}/lib/lists/groups) # TODO: include all subdirectories in /lib
    config.autoload_paths += %W(#{config.root}/lib/lists/songs) # TODO: include all subdirectories in /lib

    config.force_ssl = true

    # needed for facebook invite friends
    config.action_dispatch.default_headers = {
      'X-XSS-Protection' => '1; mode=block',
      'X-Content-Type-Options' => 'nosniff'
    }

    config.assets.precompile += ['login.css', 'application.css', 'landing.css', 'lib/bootstrap/bootstrap_and_overrides.css', 'lib/bootstrap/_variables.css']
  end
end
