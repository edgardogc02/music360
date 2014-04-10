source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.2'

gem 'mysql2'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Require file trees with Sass @import directives
gem 'sass-globbing'

# Compass Rails integration
gem 'compass-rails', github: 'compass/compass-rails', branch: "2-0-stable"

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# For user seeds
# gem 'namey'

# Use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.1.2'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

# Slugs and nice URLs
gem 'friendly_id', '~> 5.0.0'

# simple forms
gem 'simple_form'

# aomniauth and facebook authentication
gem 'omniauth'
gem 'omniauth-facebook', '1.4.0'

# paginator
gem 'kaminari'

# interact with the fb api
gem 'koala'

# interact with the echonest api
gem 'echowrap'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :development, :test do
	# Better errors
	gem 'better_errors'
  gem 'therubyracer'
  gem 'rspec-rails'
  gem 'thin'
end

group :production do
  gem 'puma'
  gem 'rails3_serve_static_assets', github: 'heroku/rails3_serve_static_assets'
end

group :test do
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'launchy'
  gem 'guard-rspec'
  gem 'zeus'
  gem 'shoulda-matchers'
end
