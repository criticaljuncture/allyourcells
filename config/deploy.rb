require "bundler"
Bundler.setup(:default, :deployment)

# hoptoad deploy notifications, etc
require 'hoptoad_notifier/capistrano'

# deploy recipes - need to do `sudo gem install thunder_punch` - these should be required last
require 'thunder_punch'


#############################################################
# Set Basics
#############################################################

set :application, "allyourcells"
set :user, "deploy"

# ssh key setup
if File.exists?(File.join(ENV["HOME"], ".ssh", "govpulse-prod-provision"))
  ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "govpulse-prod-provision")]
else
  puts "~/.ssh/govpulse-prod-provision was not available falling back to ~/.ssh/id_rsa"
  ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "id_rsa")]
end


ssh_options[:paranoid] = false
set :use_sudo, true
default_run_options[:pty] = true


#############################################################
# Git-based Deployment Setup
#############################################################

set(:latest_release)  { fetch(:current_path) }
set(:release_path)    { fetch(:current_path) }
set(:current_release) { fetch(:current_path) }

set(:current_revision)  { capture("cd #{current_path}; git rev-parse --short HEAD").strip }
set(:latest_revision)   { capture("cd #{current_path}; git rev-parse --short HEAD").strip }
set(:previous_revision) { capture("cd #{current_path}; git rev-parse --short HEAD@{1}").strip }


set :finalize_deploy, false
# we don't need this because we have an asset server
# and we also use varnish as a cache server. Thus 
# normalizing timestamps is detrimental.
set :normalize_asset_timestamps, false


set :migrate_target, :current


#############################################################
# Set Branch
#############################################################

set(:branch) { `git branch`.match(/\* (.*)/)[1] }


#############################################################
# General Settings  
#############################################################

set :rails_env,  "production"                           
set :deploy_to,  "/var/www/apps/#{application}" 
set :domain,     "ec2-184-73-55-26.compute-1.amazonaws.com" #ec2 large server             
set :url,        "#{domain}"     
set :server_url, "#{domain}"

role :proxy,  domain
role :static, domain
role :worker, domain, {:primary=>true}
role :app,    domain
role :db ,    domain, {:primary => true}


#############################################################
# Database Settings
#############################################################

set :remote_db_name, "allyourcells_production"
set :db_path,        "#{shared_path}/db"
set :sql_file_path,  "#{shared_path}/db/#{remote_db_name}_#{Time.now.utc.strftime("%Y%m%d%H%M%S")}.sql"


#############################################################
# SCM Settings
#############################################################
set :scm,              :git          
set :github_user_repo, 'criticaljuncture'
set :github_project_repo, 'allyourcells'
set :deploy_via,       :remote_cache 
set :repository, "git@github.com:#{github_user_repo}/#{github_project_repo}.git"
set :github_username, 'criticaljuncture'


#############################################################
# Git
#############################################################

# This will execute the Git revision parsing on the *remote* server rather than locally
set :real_revision, lambda { source.query_revision(revision) { |cmd| capture(cmd) } }
set :git_enable_submodules, true


#############################################################
# Bundler
#############################################################

set(:gem_file_groups) { [:development] }


#############################################################
# Run Order
#############################################################

# Do not change below unless you know what you are doing!
after "deploy:update_code",       "symlinks:create"
after "symlinks:create",          "deploy:set_rake_path"
after "deploy:set_rake_path",     "bundler:fix_bundle"
after "bundler:fix_bundle",       "deploy:migrate"
after "deploy:migrate",           "passenger:restart"


#############################################################
# Symlinks for Static Files
#############################################################
set :custom_symlinks, {
  'config/api_keys.yml'                       => 'config/api_keys.yml',
  'config/mail.yml'                           => 'config/mail.yml',
  'config/initializers/cloudkicker_config.rb' => 'config/cloudkicker_config.rb',
  
  'data' => 'data',
}




#############################################################
#                                                           #
#                                                           #
#                         Recipes                           #
#                                                           #
#                                                           #
#############################################################


#############################################################
# Create Project Directories for Capistrano
#############################################################

namespace :deploy do
  desc "Creates project directories with appropriate permissions"
  task :create_project_directories do
    sudo "mkdir -p #{deploy_to}/releases"
    sudo "mkdir -p #{deploy_to}/shared/log"
    sudo "mkdir -p #{deploy_to}/shared/data"
    sudo "mkdir -p #{deploy_to}/shared/system"
    sudo "chown -R #{user}:#{user} #{deploy_to}"
    sudo "touch #{deploy_to}/shared/log/#{rails_env}.log"
    sudo "chmod 0666 #{deploy_to}/shared/log/#{rails_env}.log"
  end
end

