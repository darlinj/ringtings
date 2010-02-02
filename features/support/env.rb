# Sets up the Rails environment for Cucumber
ENV["RAILS_ENV"] ||= "cucumber"
require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
require 'cucumber/rails/world'

require 'cucumber/formatter/unicode'

require 'cucumber/rails/rspec'
#require 'webrat/core/matchers'
#
Cucumber::Rails::World.use_transactional_fixtures = false
require 'factory_girl'
Factory.find_definitions

require 'curb'
require 'rexml/document'

require 'rake'
