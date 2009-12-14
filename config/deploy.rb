#set :application, 'cloud-portal'
set :repository,  "/home/joe/work/ringtings"
set :scm, :git

set :host, "205.143.144.234"
set :application, "ringtings"
set :application_user, "ringtings"

role :web, host
role :app, host
role :db, host, :primary => true

set :database_name, application
set :user, 'joe'
set :admin_runner, application_user
set :use_sudo, false
default_run_options[:pty] = true


def sudo_gem_install gem
  command = "gem install #{gem}"
  if exists?(:http_proxy)
    run "sudo #{command} -p #{http_proxy}"
  else
    run "sudo #{command}"
  end
end

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

# Sets a variable from environment or prompt, unless it's already set.
def set_from_user_input(message, variable, echo = false)
  unless exists?(variable)
    set(variable) {
      if echo
        Capistrano::CLI.ui.ask message
      else
        Capistrano::CLI.password_prompt message
      end
    }
    # use the variable here, just to force user input prompt
    foo = fetch(variable)
  end
end


task :after_update_code do
  run "ln -nfs #{shared_path}/config/production.rb #{release_path}/config/environments/production.rb"
  run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  run "ln -nfs #{shared_path}/cache #{release_path}/public/cache"
  run "ln -nfs #{shared_path}/views #{release_path}/tmp/views"
  run "ln -nfs #{shared_path}/uploads #{release_path}/tmp/uploads"
  run "cd #{release_path} && gem bundle --cached"
end

task :list_home do
  run "ls -la"
end

desc 'Install the Portal'
task :install do
  set :use_sudo, true
  #deploy.ask
  deploy.create_user
  deploy.install_packages
  #deploy.allow_user_to_geminstall
  deploy.create_postgres_user
  deploy.create_deployment_folders
  deploy.create_gemrc
  #deploy.install_geminstaller
  deploy.update
  deploy.correct_ownership
  deploy.database_config
  deploy.production_rb
  deploy.create_and_migrate_database
  deploy.passenger_config
  deploy.restart_apache
end

desc 'Update the Portal'
task :update do
  set :user, application_user
  deploy.migrations
  deploy.cleanup
end

namespace :deploy do

#  desc 'Recompile Ruby (to include readline)'
#  task :recompile_ruby do
#    run_with_proxy_if_set 'yum install -y readline-devel'
#    # download latest ruby - version on image doesn't work with readline
#    run_with_proxy_if_set 'wget ftp://ftp.ruby-lang.org/pub/ruby/ruby-1.8.6-p383.tar.gz'
#    run 'tar xvfz ruby-1.8.6-p383.tar.gz'
#    run 'cd ruby-1.8.6-p383 && ./configure --prefix=/usr && make && make install'
#  end

  desc 'Install require packages'
  task :install_packages do
    run_with_proxy_if_set 'yum install -y libxml2-devel libxslt libxslt-devel libxml2'
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
    try_sudo "mkdir -p #{deploy_to}/shared/cache"
    try_sudo "mkdir -p #{deploy_to}/shared/views"
    try_sudo "mkdir -p #{deploy_to}/shared/config"
    try_sudo "mkdir -p #{deploy_to}/shared/log"
    try_sudo "mkdir -p #{deploy_to}/shared/uploads"
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
    try_sudo_with_proxy_if_set "cd #{release_path} && rake db:create db:migrate RAILS_ENV=production"
  end

  task :create_gemrc do
    try_sudo "echo -e '---\\n:sources:\\n- http://gems.rubyforge.org/\\n- http://gems.github.com/\\n- http://gemcutter.org/\\ngem: --no-rdoc --no-ri' > ~#{application_user}/.gemrc"
  end

  task :install_geminstaller do
    sudo_gem_install 'geminstaller'
  end

  task :correct_ownership do
    run "chown -R #{application_user}:#{application_user} #{release_path}"
  end

  task :passenger_config do
    #run "cp #{release_path}/config/deploy/passenger_config /etc/httpd/conf.d/portal.conf"
    passenger_config = ERB.new(File.read('config/deploy/passenger_config.erb')).result(binding)
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

end
