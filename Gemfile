source "https://rubygems.org"

gem "rails", "4.2.4"
gem "pg"
gem "sass-rails", "~> 5.0"
gem "uglifier", ">= 1.3.0"
gem "coffee-rails", "~> 4.1.0"
gem "jquery-rails"
gem "jbuilder", "~> 2.0"
gem "sdoc", "~> 0.4.0", group: :doc
gem "foundation-rails"
gem 'simple_form'

group :development do
  gem "web-console", "~> 2.0"
end

group :development, :test do
  gem "capybara"
  gem "factory_girl_rails"
  gem "fuubar"
  gem "rspec-rails", "~> 3.0"
  gem "pry-rails"
  gem "shoulda-matchers"
end

group :test do
  gem "launchy", require: false
  gem "valid_attribute"
end

group :production, :staging do
  gem "rails_12factor"
end
