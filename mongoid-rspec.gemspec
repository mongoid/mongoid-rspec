# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "mongoid-rspec/version"

Gem::Specification.new do |s|
  s.name        = "mongoid-rspec"
  s.version     = Mongoid::Rspec::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Evan Sagge"]
  s.email       = %q{evansagge@gmail.com}
  s.homepage    = %q{http://github.com/evansagge/mongoid-rspec}
  s.summary     = %q{RSpec matchers for Mongoid}
  s.description = %q{RSpec matches for Mongoid models, including association and validation matchers}

  s.rubyforge_project = "mongoid-rspec"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'rake'
  s.add_dependency 'mongoid', '>= 3.0.1'
  s.add_dependency 'rspec', '>= 2.9'
end
