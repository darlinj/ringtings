$stderr.puts 'Updating bundled gems...'
system 'gem bundle --cached'
require "#{RAILS_ROOT}/vendor/bundled_gems/environment"
