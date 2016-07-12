# Change these
server '52.41.210.225', port: 22, roles: [:web, :app, :db], primary: true

set :repo_url,        'git@github.com:TaganTeam/fdaDrugs.git'
set :application,     'bshc_piv'
set :user,            'deploy'
set :puma_threads,    [4, 16]
set :puma_workers,    0

# Don't change these unless you know what you're doing
set :pty,             true
set :use_sudo,        false
set :stage,           :production
set :deploy_via,      :remote_cache
set :deploy_to,       "/home/#{fetch(:user)}/apps/#{fetch(:application)}/current"
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true  # Change to false when not using ActiveRecord
set :bower_flags, '--quiet --config.interactive=false'
set :bower_roles, :web
set :bower_target_path, lambda {"#{release_path}"}
set :bower_bin, :bower
set :linked_files, %w{config/database.yml config/secrets.yml}
set :rails_env, "production"

set :delayed_job_workers, 1
set :delayed_job_prefix, 'parsers'
# set :delayed_job_queues, ['defaulf']
## Defaults:
# set :scm,           :git
# set :branch,        :master
# set :format,        :pretty
# set :log_level,     :debug
# set :keep_releases, 5

## Linked Files & Directories (Default None):
# set :linked_files, %w{config/database.yml}
set :linked_dirs,  %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

#set :linked_dirs, %w{tmp/pids}

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end

namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
      # invoke 'delayed_job:stop'
      # invoke 'delayed_job:start'
    end
  end

  before :starting,     :check_revision
  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
  after  :finishing,    :restart

  after  :starting,    :compile_assets
  after  :finishing,    :cleanup
  after  :finishing,    :restart
end


# namespace :delayed_job do
#
#   desc "Install Deployed Job executable if needed"
#   task :install do
#     on roles(delayed_job_roles) do |host|
#       within release_path do
#         # Only install if not already present
#         unless test("[ -f #{release_path}/#{delayed_job_bin} ]")
#           with rails_env: fetch(:rails_env) do
#             execute :bundle, :exec, :rails, :generate, :delayed_job
#           end
#         end
#       end
#     end
#   end
#
#   before :start, :install
#   before :restart, :install
#
# end

# namespace :rake do
#   desc "Run a task on a remote server."
#   # run like: cap staging rake:invoke task=a_certain_task
#   task :invoke do
#     run("cd #{deploy_to}/current; nohup /usr/bin/env rake jobs:work RAILS_ENV=#{rails_env} --trace > rake.out 2>&1 &")
#   end
# end
#
# after 'deploy:published', 'delayed_job:restart' do
#   invoke 'delayed_job:stop'
#   invoke 'delayed_job:start'
# end
# ps aux | grep puma    # Get puma pid
# kill -s SIGUSR2 pid   # Restart puma
# kill -s SIGTERM pid   # Stop puma
