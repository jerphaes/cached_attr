require 'bundler/setup'
require 'rspec/autorun'
require 'simplecov'

unless ENV['COVERAGE'] == 'no'
  require 'simplecov'
  SimpleCov.start do
    add_filter "/spec/"
  end
end

require 'cached_attr'
