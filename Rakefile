
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

task :default => :test

RSpec::Core::RakeTask.new(:test)

RuboCop::RakeTask.new do |task|
  task.requires << 'rubocop-rspec'
end
