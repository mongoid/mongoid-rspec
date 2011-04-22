$:.push File.expand_path("../lib", __FILE__)

require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task :default => :spec
task :test => :spec

require 'rake/rdoctask'
require "mongoid-rspec/version"
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "mongoid-rspec #{Mongoid::Rspec::VERSION}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
