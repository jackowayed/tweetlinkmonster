set :application, "tweetlinkmonster"
set :repository,  "git@github.com:ivey/tweetlinkmonster.git"

set :deploy_to, "~/apps/#{application}"

set :use_sudo, false


# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
default_run_options[:pty] = true
set :deploy_via, :copy
set :copy_strategy, :export

set :user, "tlm"
#set :git_user, "danieljdel"

set :scm, :git
set :branch, "master"
set :scm_user, "jackowayed"
#set :deploy_via, :remote_cache
set :repository_cache, "git_master"
set :remote, "#{scm_user}"

role :app, "www.tweetlinkmonster.com"
role :web, "www.tweetlinkmonster.com"
role :db, "www.tweetlinkmonster.com", :primary => true



namespace :deploy do
  #desc "Start Merb Instances"
  #task :start do
    #run "merb -a #{adapter} -e production -c #{processes} --port #{start_port} -m #{current_path} -l #{log_level} -L #{log_path}"
  #end

  #desc "Stop Merb Instances"
  #task :stop do
    #run "cd #{current_path} && merb -a #{adapter} -k all"
  #end

  #desc 'Custom restart task for Merb'
  #task :restart, :roles => :app do
    #deploy.stop
    #deploy.start
  #end
  desc "Restart the web server. Overrides the default task for Site5 use"
  task :restart, :roles => :app do
    run "cd /home/#{user}; rm -rf public_html; ln -s #{current_path}/publ
ic ./public_html"
  run "skill -9 -u #{user} -c merb.fcgi"
  end

  desc "Migrate the database"
  task :migrate do
    run "cd #{current_release}; ~/lib/ruby/gems/1.8/gems/rake-0.8.3/bin/rake dm:db:automigrate MERB_ENV=production"
  end

  desc "Do a full deployment"
  task :long do
    ENV['REASON'] ||= "a fresh batch of new software"
    ENV['UNTIL'] ||= (Time.now + 60 * 15).strftime("around %I:%M %p %Z")
    deploy.web.disable
    deploy.migrations
    sleep 10
    deploy.web.enable
  end

  desc "Do a quick deployment"
  task :quick do
    ENV['REASON'] ||= "a quick update"
    ENV['UNTIL'] ||= "momentarily"
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
    # note to self: learn this syntax
    desc <<-DESC
Present a maintenance page to visitors. Disables your application's web \
interface by writing a "maintenance.html" file to each web server. The \
servers must be configured to detect the presence of this file, and if \
it is present, always display it instead of performing the request.

By default, the maintenance page will just say the site is down for \
"maintenance", and will be back "shortly", but you can customize the \
page by specifying the REASON and UNTIL environment variables:

$ cap deploy:web:disable \\
REASON="hardware upgrade" \\
UNTIL="12pm Eastern Time"

Further customization will require that you write your own task.
DESC
    task :disable, :roles => :web, :except => { :no_release => true } do
      require 'rubygems'
      require 'haml'
      require 'rss/1.0'
      require 'rss/2.0'
      on_rollback { run "rm #{shared_path}/system/maintenance.html" }

      started = ENV['STARTED']
      reason = ENV['REASON']
      deadline = ENV['UNTIL']
      #tz = TZInfo::Timezone.get('America/New_York')

      template = File.read('./app/views/layout/maintenance.html.haml')
      result = Haml::Template.new(template).render(binding)

      put result, "#{shared_path}/system/maintenance.html", :mode => 0644
    end
  end

  after deploy.symlink do
    run "chmod g-w -R ~/apps/tweetlinkmonster/"
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

