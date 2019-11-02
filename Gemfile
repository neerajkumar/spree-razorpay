source "https://rubygems.org"

gem 'razorpay'
gem 'spree_core', '>= 3.1.0', '< 4.0'
gem 'byebug'

gem 'sassc-rails'

group :test do
  gem 'sqlite3'
  gem 'rspec-rails'
  gem 'ffaker'
  gem 'factory_bot_rails'
  gem 'database_cleaner'
  gem 'spree_extension'
  gem 'spree_frontend'
  gem 'rails-controller-testing'
  unless ENV['WITHOUT_SPREE_AUTH_DEVISE'] == 'true'
    gem 'spree_auth_devise'
  end
  gem 'coffee-rails'
end

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

# Specify your gem's dependencies in spree-razorpay.gemspec
gemspec
