require 'coverage_helper'
require 'rspec/collection_matchers'
require 'pry'

puts 'INSIDE MY spec_helper_acceptance_local.rb file!!!!!'

['puppetlabs-stdlib', 'puppetlabs-dsc'].each do |m|
  system("bundle exec puppet module install #{m} --force")
  if $? != 0 #check if the child process exited cleanly.
    puts "got an error during puppet module install!"
  end
end

system('git clone https://github.com/tragiccode/tragiccode-ravendb C:\ProgramData\PuppetLabs\code\environments\production\modules\ravendb')
if $? != 0 #check if the child process exited cleanly.
  puts "got an error during puppet module install!"
end


system("bundle exec puppet apply --execute \"class { 'ravendb': package_ensure => 'present', ravendb_port => 8081, }\"")