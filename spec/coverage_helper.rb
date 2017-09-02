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

SimpleCov.minimum_coverage 75