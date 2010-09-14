# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_view.cache_template_loading            = true

# See everything in the log (default is :info)
config.log_level = :debug

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Use a different cache store in production
# config.cache_store = :mem_cache_store

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host = "http://assets.example.com"

# Enable threaded mode
# config.threadsafe!

# Clearance stuff
HOST="localhost"

ActionMailer::Base.delivery_method = :test

VOICEMAIL_HOST = "http://192.168.0.4:8080"
VOICEMAIL_INDEX_URI = "#{VOICEMAIL_HOST}/api/voicemail/web"
VOICEMAIL_GET_URI = "#{VOICEMAIL_HOST}/api/voicemail/get"
VOICEMAIL_DELETE_URI = "#{VOICEMAIL_HOST}/api/voicemail/del"
