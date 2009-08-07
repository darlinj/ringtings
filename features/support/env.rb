# Sets up the Rails environment for Cucumber
ENV["RAILS_ENV"] ||= "cucumber"
require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
require 'cucumber/rails/world'

require 'cucumber/formatter/unicode'

require 'cucumber/rails/rspec'
#require 'webrat/core/matchers'
