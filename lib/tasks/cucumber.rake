$LOAD_PATH.unshift(RAILS_ROOT + '/vendor/plugins/cucumber/lib') if File.directory?(RAILS_ROOT + '/vendor/plugins/cucumber/lib')

begin
  require 'cucumber/rake/task'

  task :run_features => [:'features:webrat']

  namespace :features do
    Cucumber::Rake::Task.new(:e2e) do |t|
      t.fork = true
      t.cucumber_opts = ['--profile e2e RAILS_ENV=cucumber']
    end
    Cucumber::Rake::Task.new(:webrat) do |t|
      t.fork = true
      t.cucumber_opts = ['--profile default ']
    end
  end

rescue LoadError
  desc 'Cucumber rake task not available'
  task :features do
    abort 'Cucumber rake task is not available. Be sure to install cucumber as a gem or plugin'
  end
end
