require 'simplecov'
require 'simplecov-console'

SimpleCov.formatters = [
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::Console
]
SimpleCov.start do
  track_files 'lib/**/*.rb'
  add_filter '/.bundle/'
end
# Not suitable until i further abstract out http requests
# SimpleCov.minimum_coverage 75