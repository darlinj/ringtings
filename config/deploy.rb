set :repository,  "/home/joe/work/ringtings"
set :scm, :git
set :deploy_via, :copy
set :copy_strategy, :export

#EMI that includes rails and postgres is 	emi-4F901695
#You need to go into /etc/yum.repos.d/Centos-Base and change the achitecture variable to "i386"
set :host, "ringtings.com"
set :application, "ringtings"
set :application_user, "ringtings"
set :deploy_to, "/home/#{application_user}/ringtings_home"

role :app, host
role :db, host, :primary => true

set :database_name, "#{application}_production"
set :user, 'root'
set :admin_runner, "ringtings" #application_user
default_run_options[:pty] = true

def run_with_proxy_if_set command
  if exists?(:http_proxy)
    run "bash -c 'export http_proxy=#{http_proxy} && export HTTP_PROXY=$http_proxy && #{command}'"
  else
    run "#{command}"
  end
end

def try_sudo_with_proxy_if_set command
  if exists?(:http_proxy)
    try_sudo "bash -c 'export http_proxy=#{http_proxy} && export HTTP_PROXY=$http_proxy && #{command}'"
  else
    try_sudo "#{command}"
  end
end

task :after_update_code do
  run "ln -nfs #{shared_path}/config/production.rb #{release_path}/config/environments/production.rb"
  run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  run "cd #{release_path} && gem bundle"
end

desc 'Install ringtings'
task :install do
  set :use_sudo, true
  deploy.create_user
  deploy.install_packages
  deploy.create_postgres_user
  deploy.create_deployment_folders
  deploy.create_gemrc
  deploy.update_rubygems
  deploy.install_bundler
  deploy.update
  deploy.correct_ownership
  deploy.database_config
  deploy.production_rb
  deploy.create_and_migrate_database
  deploy.passenger_config
  deploy.restart_apache
  deploy.install_freeswitch
end

desc 'Update ringtings'
task :update do
  set :user, application_user
  deploy.migrations
  deploy.cleanup
end

namespace :deploy do

  desc 'Install require packages'
  task :install_packages do
    run_with_proxy_if_set 'yum install -y libxml2-devel libxslt libxslt-devel libxml2 curl-devel'
  end

  desc 'Create application user'
  task :create_user do
    run "id #{application_user} >/dev/null 2>&1 ; if [[ \"$?\" -ne \"0\" ]]; then useradd -m #{application_user}; fi"
    #correct permissions to allow apache/passenger to see the home folder
    run "chmod 755 /home/#{application_user}"
  end

  task :allow_user_to_geminstall do
    run "echo '#{application_user} ALL = NOPASSWD: /usr/bin/geminstaller, /usr/bin/ruby, /usr/bin/gem' >> /etc/sudoers"
  end

  task :create_deployment_folders do
    try_sudo "mkdir -p #{deploy_to}/releases"
    try_sudo "mkdir -p #{deploy_to}/shared/config"
    try_sudo "mkdir -p #{deploy_to}/shared/log"
    try_sudo "mkdir -p #{deploy_to}/shared/system"
  end

  task :create_postgres_user do
    run "su postgres -c 'if [[ $(psql -c \"\\du\" | grep #{application_user} | wc -l) -eq \"0\" ]]; then createuser -S -d -R #{application_user}; fi'"
  end

  task :database_config do
#    try_sudo "cp #{release_path}/config/database.yml.production #{shared_path}/config/database.yml"
    database_configuration = <<-"EOF"
production:
  adapter: postgresql
  database: #{database_name}
  username: #{application_user}
     EOF
    run "mkdir -p #{shared_path}/config/"
    put database_configuration, "#{shared_path}/config/database.yml"
  end

  task :production_rb do
    production_config = ERB.new(File.read('config/environments/production.rb.erb')).result(binding)
    put production_config, "#{shared_path}/config/production.rb"
    run "chown #{application_user}:#{application_user} #{shared_path}/config/production.rb"
  end

  # not using the built in migrate task because it doesn't use 'try_sudo'
  task :create_and_migrate_database do
    run "chown -R #{application_user}:#{application_user} #{shared_path}/log"
    # wrapping the following command with a 'bash -c' because it contains a 'cd' which doesn't work under sudo otherwise.
    try_sudo_with_proxy_if_set "bash -c 'cd #{release_path} && rake db:create db:migrate RAILS_ENV=production'"
  end

  task :update_rubygems do
    run "gem update --system"
  end

  task :install_bundler do
    run "gem install bundler"
  end

  task :create_gemrc do
    try_sudo "echo -e '---\\n:sources:\\n- http://gems.rubyforge.org/\\n- http://gems.github.com/\\n- http://gemcutter.org/\\ngem: --no-rdoc --no-ri' > ~#{application_user}/.gemrc"
  end

  task :correct_ownership do
    run "chown -R #{application_user}:#{application_user} #{release_path}"
  end

  task :passenger_config do
    #run "cp #{release_path}/config/deploy/passenger_config /etc/httpd/conf.d/ringtings.conf"
    passenger_config = ERB.new(File.read('config/passenger_config.erb')).result(binding)
    put passenger_config, "/etc/httpd/conf.d/#{application}.conf"
  end

  task :restart_apache do
    run 'apachectl restart'
  end

  desc 'Restart passenger'
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with passenger"
    task t, :roles => :app do ; end
  end

  task :install_freeswitch do
    run_with_proxy_if_set 'yum install -y ncurses-devel'
    run "cd /usr/local/freeswitch/ && wget http://files.freeswitch.org/freeswitch-1.0.4.tar.gz"
    run "cd /usr/local/freeswitch/ && tar xvfz freeswitch-1.0.4.tar.gz"
    run "cp #{current_path}/freeswitch_stuff/modules.conf /usr/local/freeswitch/freeswitch-1.0.4/"
    run "cd /usr/local/freeswitch/freeswitch-1.0.4/ && ./configure"
    run "cd /usr/local/freeswitch/freeswitch-1.0.4/ && make"
    run "cd /usr/local/freeswitch/freeswitch-1.0.4/ && make install"
    run "cp #{current_path}/freeswitch_stuff/xml_curl.conf.xml /usr/local/freeswitch/conf/autoload_configs/"
    run "cp #{current_path}/freeswitch_stuff/suckingteeth.wav /usr/local/freeswitch/sounds/en/us/callie/ivr/8000/"
  end
end
