require 'bundler'
require 'rake/clean'
require 'rspec/core/rake_task'
require 'cucumber/rake/task'

include Rake::DSL

Bundler::GemHelper.install_tasks

RSpec::Core::RakeTask.new do |t|
  # Put spec opts in a file named .rspec in root
end

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format pretty -x"
  t.fork = false
end

task :default => [:spec,:features]
