# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
# require 'rspec/autorun'

require 'capybara/rails'
require 'capybara/rspec'

require 'capybara/poltergeist'
Capybara.register_driver :poltergeist_debug do |app|
  Capybara::Poltergeist::Driver.new(app, inspector: true)
end

Capybara.configure do |config|
#  config.default_driver = :poltergeist
  config.javascript_driver = :poltergeist
  config.run_server = false
  config.app_host = ENV['APP'] || 'https://instrumentchamp-local.lvh.me:3000'
  Capybara.server_port = 3000
  config.default_wait_time = 10
end

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  config.include FactoryGirl::Syntax::Methods

  config.include(MailerMacros)
  config.include(OmniauthMacros)
  config.include(LoginMacros)
  config.include(FacebookLoginMacros)
  config.include(FacebookFriendsMacros)
  config.include(UserOmniauthCredentialsMacros)
  config.include(UserMacros)
  config.before(:each) { reset_email }

  config.include Capybara::DSL
end

OmniAuth.config.test_mode = true

require 'sidekiq/testing'
Sidekiq::Testing.fake!
