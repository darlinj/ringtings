Rake.application.instance_variable_get('@tasks').delete('default')
#task :default => [ "db:migrate", "db:seed", :spec, "restart", "db:seed", "features", :ok ]
task :default => [:'db:migrate:all'] do
  #reports = ['log/spec.html', 'coverage', 'log/roodi.txt', 'log/features_ok.html',
    #'log/features_wip.html', 'log/stats.txt'].map {|f| File.dirname(__FILE__) + '/../../' + f}

  begin
    RAILS_ENV = ENV['RAILS_ENV'] = 'test'
    # don't do these as dependencies, otherwise the ensure block never gets called
    #system 'rake report_stats' # creates empty file if run in same process
    ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations["test"])
    Rake::Task['db:seed'].invoke
    Rake::Task['spec:rcov'].invoke
    Rake::Task['spec:verify_rcov'].invoke
    Rake::Task['roodi'].invoke
    ENV['RAILS_ENV'] = 'cucumber'
    Rake::Task['db:seed'].invoke
    Rake::Task['cucumber:all'].invoke
    #if ENV['USER'] =~ /^cruise/
      #Rake::Task[:deploy].invoke
    #end
    Rake::Task['ok'].invoke
  #ensure
    ## copy build reports
    #if ENV['CC_BUILD_ARTIFACTS']
      #reports.each do |report|
        #cp_r report, ENV['CC_BUILD_ARTIFACTS'] if File.exist? report
      #end
    #end
  end
end


task :ok do
  red    = "\e[31m"
  yellow = "\e[33m"
  green  = "\e[32m"
  blue   = "\e[34m"
  purple = "\e[35m"
  bold   = "\e[1m"
  normal = "\e[0m"
  puts "", "#{bold}#{red}*#{yellow}*#{green}*#{blue}*#{purple}* #{green} ALL TESTS PASSED #{purple}*#{blue}*#{green}*#{yellow}*#{red}*#{normal}"
end

