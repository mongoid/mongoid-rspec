require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "mongoid-rspec"
    gem.summary = %Q{RSpec matchers for Mongoid}
    gem.description = %Q{RSpec matches for Mongoid models, including association and validation matchers}
    gem.email = "evansagge@gmail.com"
    gem.homepage = "http://github.com/evansagge/mongoid-rspec"
    gem.authors = ["Evan Sagge"]
    gem.add_dependency "mongoid", "~> 2.0.0.rc.7"
    gem.add_dependency "rspec", "~> 2"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rspec/core'
require 'rspec/core/rake_task'

task :default => :spec

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = "./spec/**/*_spec.rb"
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = "./spec/**/*_spec.rb"
  spec.rcov = true
end

# task :spec => :check_dependencies

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "mongoid-rspec #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end


