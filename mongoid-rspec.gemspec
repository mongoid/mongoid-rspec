$:.push File.expand_path('../lib', __FILE__)

require 'mongoid/rspec/version'

Gem::Specification.new do |s|
  s.name        = 'mongoid-rspec'
  s.version     = Mongoid::RSpec::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Evan Sagge', 'Rodrigo Pinto']
  s.email       = 'evansagge@gmail.com contato@rodrigopinto.me'
  s.homepage    = 'http://github.com/mongoid-rspec/mongoid-rspec'
  s.summary     = 'RSpec matchers for Mongoid'
  s.description = 'RSpec matches for Mongoid models, including association and validation matchers.'
  s.license     = 'MIT'

  s.required_ruby_version     = '>= 2.2'
  s.required_rubygems_version = '>= 1.3.6'
  s.rubyforge_project         = 'mongoid-rspec'

  s.add_dependency 'mongoid', '>= 2.0'
  s.add_dependency 'rspec',   '~> 3.3'
  s.add_dependency 'activesupport', '>= 3.0.0'
  s.add_development_dependency 'rake', '~> 10.0'
  s.add_dependency 'mongoid-compatibility'

  s.files        = Dir.glob('lib/**/*') + %w(LICENSE README.md Rakefile)
  s.test_files   = Dir.glob('spec/**/*')
  s.require_path = 'lib'
end
