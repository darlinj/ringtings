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
set :freeswitch_dir, "/usr/local/freeswitch"

default_environment['SWIFT_HOME'] = "/opt/swift"

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
  run "cd #{release_path} && bundle install"
end

desc 'Install ringtings'
task :install do
  set :use_sudo, true
  deploy.create_user
  deploy.install_packages
  deploy.install_ruby
  deploy.install_rubygems
  deploy.install_passenger
  deploy.install_postgres
  deploy.install_sendmail
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
  deploy.install_tts_voice
  deploy.install_freeswitch
end

desc 'Update ringtings'
task :update do
  set :user, 'root'
  deploy.update
  deploy.correct_ownership
  deploy.migrate_database
  deploy.restart_apache
end

namespace :deploy do

  desc 'Install require packages'
  task :install_packages do
    run 'yum install -y httpd libxml2-devel libxslt libxslt-devel libxml2 curl-devel glibc glibc-devel'
    run 'yum install -y expect'
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

  task :install_ruby do
    set :ruby_version, "ruby-1.8.6-p383"
    run 'yum install -y gcc make readline-devel'
    # download latest ruby - version on image doesn't work with readline
    run "wget ftp://ftp.ruby-lang.org/pub/ruby/1.8/#{ruby_version}.tar.gz"
    run "tar xvfz #{ruby_version}.tar.gz"
    run "cd #{ruby_version} && ./configure --prefix=/usr && make && make install"
    run "rm -f #{ruby_version}.tar.gz"
    run "rm -rf #{ruby_version}"
  end

  task :install_rubygems do
    run "cd /tmp && wget http://rubyforge.org/frs/download.php/60718/rubygems-1.3.5.tgz"
    run "cd /tmp && tar -xvf rubygems-1.3.5.tgz"
    run "cd /tmp/rubygems-1.3.5 && ruby setup.rb"
  end

  task :install_passenger do
    run 'yum install -y httpd-devel apr-devel'
    run 'gem install passenger -v 2.2.8'
    run "/usr/bin/expect -d -c 'set timeout -1; spawn passenger-install-apache2-module; sleep 1; send -- \\r; sleep 4; send -- \\r; expect eof'"
  end

  task :install_postgres do
    run "yum install -y postgresql"
    run "yum install -y postgresql-server"
    # Had a problem on Amazon with it asking me to run somthing like "service database init"
    run "/etc/init.d/postgresql start"
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

  task :migrate_database do
    try_sudo "bash -c 'cd #{release_path} && rake db:migrate RAILS_ENV=production'"
  end

  task :update_rubygems do
    run "gem update --system"
  end

  task :install_bundler do
    run "gem install bundler -v 0.6.0"
  end

  task :create_gemrc do
    try_sudo "echo -e '---\\n:sources:\\n- http://gems.rubyforge.org/\\n- http://gems.github.com/\\n- http://gemcutter.org/\\ngem: --no-rdoc --no-ri' > ~#{application_user}/.gemrc"
  end

  task :correct_ownership do
    run "chown -R #{application_user}:#{application_user} #{release_path}"
  end

  task :passenger_config do
    top.upload("config/passenger_site_config", "/etc/httpd/conf.d/001_passenger_site.conf")
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

  task :install_tts_voice do
    set :voice, "Cepstral_Lawrence-8kHz_i386-linux_5.1.0"
    run 'yum install -y expect'
    run "mkdir -p #{freeswitch_dir}/downloads"
    run "mkdir -p #{freeswitch_dir}/downloads"
    run "cd #{freeswitch_dir}/downloads && wget http://downloads.cepstral.com/cepstral/i386-linux/#{voice}.tar.gz"
    run "cd #{freeswitch_dir}/downloads && tar -xvf #{voice}.tar.gz"
    run "cd #{freeswitch_dir}/downloads && cp -r #{voice} /opt"
    run "rm -rf /opt/swift"
    run "cd /opt/#{voice} && /usr/bin/expect -d -c 'set timeout -1; spawn ./install.sh; sleep 1; send -- q; sleep 1; send -- yes\\r; send -- \\r; send -- y\\r; send -- yes\\r; sleep 5; expect eof'"
    run "if ! grep -q '/opt/swift/lib' /etc/ld.so.conf;then echo '/opt/swift/lib' >> /etc/ld.so.conf; fi"
    run "cd /opt/#{voice} && ldconfig"
    run 'swift --reg-voice --customer-name "J Darling" --company-name "" --voice-name "Lawrence-8kHz" --license-key "a7-15c271-556301-ef7d81-b43bec-9d604e"'
  end

  task :install_freeswitch do
    run 'yum install -y ncurses-devel gcc-c++'
    run "cd /usr/local/freeswitch/ && wget http://files.freeswitch.org/freeswitch-1.0.4.tar.gz"
    run "cd /usr/local/freeswitch/ && tar xvfz freeswitch-1.0.4.tar.gz"
    run "cp #{current_path}/freeswitch_stuff/modules.conf /usr/local/freeswitch/freeswitch-1.0.4/"
    #May need to add the --without_libcurl option for some centos boxes
    run "cd /usr/local/freeswitch/freeswitch-1.0.4/ && ./configure"
    run "cd /usr/local/freeswitch/freeswitch-1.0.4/ && make"
    run "cd /usr/local/freeswitch/freeswitch-1.0.4/ && make install sounds-install moh-install"
    deploy.configure_freeswitch
  end

  task :configure_freeswitch do
    run "cp #{current_path}/freeswitch_stuff/xml_curl.conf.xml /usr/local/freeswitch/conf/autoload_configs/"
    run "cp #{current_path}/freeswitch_stuff/modules.conf.xml /usr/local/freeswitch/conf/autoload_configs/"
    run "cp #{current_path}/freeswitch_stuff/suckingteeth.wav /usr/local/freeswitch/sounds/en/us/callie/ivr/8000/"
    run "cp #{current_path}/freeswitch_stuff/dialplan_default.xml /usr/local/freeswitch/conf/dialplan/default.xml"
    # Remember to set the username and password for your gafachi account
    run "cp #{current_path}/freeswitch_stuff/gafachi.xml.example /usr/local/freeswitch/conf/sip_profiles/external/gafachi.xml"
  end

  task :install_sendmail do
    run 'yum install -y sendmail'
    run '/etc/init.d/sendmail start'
    #########  HOSTS FILE #############
    #The hosts file must be changed so that it has the following entry high in the file
    # 127.0.0.1 ringtings.com [boxname] localhost
    # remove all other references to localhost et
  end
end
