set :application, "tweetlinkmonster"
set :repository,  "git@github.com:ivey/tweetlinkmonster.git"

set :deploy_to, "~/#{application}"

set :repository_cache, "#{application}-src"

set :adapter, 'mongrel'
set :start_port, 5000
set :processes, 1
set :log_path, "#{shared_path}/log/production.log"
set :log_level, "info"

set :scm, :git
#default_run_options[:pty] = true
set :deploy_via, :remote_cache#:copy
set :ssh_options, :forward_agent => true
# set :copy_cache, true
# set :copy_exclude, ".git/*"
#set :copy_strategy, :export
set :keep_releases, 3

set :user, "tlm"
set :password, "yourpass"

role :app, "www.tweetlinkmonster.com"
role :web, "www.tweetlinkmonster.com"
role :db,  "www.tweetlinkmonster.com", :primary => true

namespace :deploy do
  namespace :symlinks do
    desc "Link in the cache directory"
    task :cache do
      run "mkdir -p #{release_path}/tmp"
      run "ln -nfs #{shared_path}/tmp/cache #{release_path}/tmp/cache"
    end
  
    desc "Link in the log directory"
    task :log do
      run "ln -nfs #{shared_path}/log #{release_path}/log"
    end
    
    desc "Do all the symlinks"
    task :all do
      cache
      log
    end
  end

  desc "Start Merb Instances"  
  task :start do
    run "merb -a #{adapter} -e production -c #{processes} --port #{start_port} -m #{current_path} -l #{log_level} -L #{log_path}"  
  end 

  desc "Stop Merb Instances"
  task :stop do
    run "cd #{current_path} && merb -a #{adapter} -K all"
  end

  desc "Totally Stop All Merb (skill)"  
  task :hardstop do 
    run "cd #{current_path} && skill merb" #-a #{adapter} -K all"  
    sleep 1
    run "skill -9 merb"
  end 

  desc 'Custom restart task for Merb'
  task :restart, :roles => :app do 
    deploy.stop 
    deploy.start 
  end
  
  desc "Rolling restart the mongrels"
  task :rolling, :roles => :app do
    processes.times do |x|
      port = start_port + x
      run "cd #{current_path} && merb -k #{port}"
      run "merb -a #{adapter} -e production -d --port #{port} -m #{current_path} -l #{log_level} -L #{log_path}"
      sleep 5
    end
  end
  
  desc "Migrate the database"
  task :migrate do
    run "cd #{current_release}; rake db:migrate MERB_ENV=production"
  end
  
  desc "Do a full deployment"
  task :long do
    ENV['REASON'] ||= "a fresh batch of new software"
    ENV['UNTIL']  ||= (Time.now + 60 * 15).strftime("around %I:%M %p %Z")
    deploy.web.disable
    deploy.migrations
    sleep 10
    deploy.web.enable
  end

  desc "Do a quick deployment"
  task :quick do
    ENV['REASON'] ||= "a quick update"
    ENV['UNTIL']  ||= "momentarily"
    transaction do
      deploy.update_code
      deploy.web.disable
      deploy.symlink
      deploy.restart
    end
    sleep 10
    deploy.web.enable
  end
  
  desc "Sneak in a really quick deployment"
  task :sneak do
    transaction do
      deploy.update_code
      deploy.symlink
      deploy.rolling
    end
  end
  
  namespace :web do
    desc <<-DESC
      Present a maintenance page to visitors. Disables your web \
      interface by writing a "maintenance.html" file to each web server. The \
      servers must be configured to detect the presence of this file, and if \
      it is present, always display it instead of performing the request.

      By default, the maintenance page will just say the site is down for \
      "maintenance", and will be back "shortly", but you can customize the \
      page by specifying the REASON and UNTIL environment variables:

        $ cap deploy:web:disable \\
              REASON="hardware upgrade" \\
              UNTIL="12pm Central Time"

      Further customization will require that you write your own task.
    DESC
    task :disable, :roles => :web, :except => { :no_release => true } do
      require 'rubygems'
      require 'haml'
      require 'rss/1.0'
      require 'rss/2.0'
      on_rollback { run "rm #{shared_path}/system/maintenance.html" }

      #started = ENV['STARTED'] || Time.now
      #reason = ENV['REASON']   || "Maintenance"
      #deadline = ENV['UNTIL']  || Time.now #+ 15.minutes
      #tz = TZInfo::Timezone.get('America/New_York')

      started = Time.now
      reason = "Maintenance"
      deadline = Time.now

      template = File.read('./app/views/layout/maintenance.html.haml')
      result = Haml::Engine.new(template).render(Object.new, {:started => started, :reason => reason, :deadline => deadline})

      puts result
      put result, "#{shared_path}/system/maintenance.html", :mode => 0644
    end
   end
  
end

namespace :logs do
  desc "Watch the logs"
  task :production do
    run "cd #{current_path} && tail -f #{log_path}"
  end
end

namespace :monit do
  desc "Get monit status"
  task :status do
    run "sudo /usr/sbin/monit status"
  end

  desc "Get monit summary"
  task :summary do
    run "sudo /usr/sbin/monit summary"
  end
end

namespace :nginx do
  desc "Restart Nginx"
  task :restart do
    nginx.stop
    nginx.start
  end

  desc "Start Nginx"
  task :start do
    run "sudo /etc/init.d/nginx start"
  end
  
  desc "Stop Nginx"
  task :stop do
    run "sudo /etc/init.d/nginx stop"
  end
  
end

after "deploy:update_code", "deploy:symlinks:all"

desc "Push to Github"
task :push do
  `git push`
end

namespace :db do
  namespace :sessions do
    desc "Clear old database-stored sessions" 
    task :clear, :roles => :app do
      run "cd #{current_path} && " << %q|merb -r 'Merb::ActiveRecordSession.destroy_all( ["updated_at < ?", 1.week.ago ] )' -e production|
    end

    desc "Count database sessions"
    task :count, :roles => :app do
      run "cd #{current_path} && " << %q|merb -r 'puts "Storing #{Merb::ActiveRecordSession.count} sessions"' -e production|
    end
  end
end
namespace :stats do
  desc "show all users with count"
  task :user_count do
    run "cd ~ && ./count_tlm_users.sh"
  end
  task :crontail do
    run "cd ~ && tail cronlog.log"
  end
end
