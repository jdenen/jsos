require "simplecov"
SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'jsos'

RSpec.configure do |config|
  config.color = true
end
