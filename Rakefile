require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'pry'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = ['--color']
  t.exclude_pattern = "spec/acceptance/*"
end

task :default => :spec

desc "Run beaker acceptance tests"
RSpec::Core::RakeTask.new(:beaker) do |t|
  t.rspec_opts ||= []
  t.rspec_opts << "--color"
  if (ENV['APPVEYOR'])
    ENV['BEAKER_localmode'] = 'yes'
  end
  if (ENV['BEAKER_localmode'])
    t.rspec_opts << "-r ./spec/spec_helper_acceptance_local"
  else
    t.rspec_opts << "-r ./spec/spec_helper_acceptance"
  end
  t.pattern = 'spec/acceptance'
end
