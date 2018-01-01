source 'https://rubygems.org'

# Specify your gem's dependencies in `mongoid-rspec.gemspec`.
gemspec

case version = ENV['MONGOID_VERSION'] || '6.0'
when /^6/
  gem 'mongoid', '~> 6.0'
when /^5/
  gem 'mongoid', '~> 5.0'
when /^4/
  gem 'mongoid', '~> 4.0'
when /^3/
  gem 'mongoid', '~> 3.1'
when /^2/
  gem 'mongoid', '~> 2.0'
  gem 'bson_ext', platforms: :ruby
else
  gem 'mongoid', version
end

group :test do
  gem 'mongoid-danger', '~> 0.1.1', require: false
end