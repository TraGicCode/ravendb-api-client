require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

desc "Run beaker acceptance tests"
RSpec::Core::RakeTask.new(:beaker) do |t|
  t.rspec_opts = ['--color']
  t.pattern = 'spec/acceptance'
end
