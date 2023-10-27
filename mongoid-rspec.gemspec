# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __FILE__)

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

  s.required_ruby_version     = '>= 2.6'
  s.required_rubygems_version = '>= 1.3.6'
  s.rubyforge_project         = 'mongoid-rspec'
  s.metadata['rubygems_mfa_required'] = 'true'

  s.add_development_dependency 'mongoid-danger', '~> 0.2'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rails'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rubocop', '~> 1.36.0'

  s.add_dependency 'mongoid', '>= 3.0', '< 9.0'
  s.add_dependency 'mongoid-compatibility', '>= 0.5.1'

  s.files        = Dir.glob('lib/**/*') + %w[LICENSE README.md Rakefile]
  s.require_path = 'lib'
end
