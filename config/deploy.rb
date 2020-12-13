# config valid for current version and patch releases of Capistrano
lock "~> 3.14.1"

set :application, "geekweibo"
set :repo_url, "git@github.com:ChrisZou/geekweibo.git"
set :deploy_to, "/var/www/#{fetch(:application)}"

set :pty,             true

set :user,            'chris'
set :puma_workers,    0
set :puma_bind,       "unix:///var/run/rails.#{fetch(:application)}.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true # Change to true if using ActiveRecord
set :keep_releases, 5

# Defaults to :db role
set :migration_role, :db

# Skip migration if files in db/migrate were not modified
# Defaults to false
set :conditionally_migrate, true

# Default value for :linked_files is []
append :linked_files, 'config/database.yml'
append :linked_files, 'config/master.key'
append :linked_files, 'localstorage.store'

# Default value for linked_dirs is []
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system', 'public/packs', 'node_modules', '.bundle'

# Default value for default_env is {}
set :default_env, PATH: '$PATH:/home/linuxbrew/.linuxbrew/bin:/opt/ruby/bin', 'NODE_ENV' => 'production'


namespace :deploy do
  desc 'Make sure local git is in sync with remote.'
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts 'WARNING: HEAD is not the same as origin/master'
        puts 'Run `git push` to sync changes.'
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

  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke! 'puma:restart'
    end
  end

  before :starting,     :check_revision
  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
  after  :finishing,    :make_dirs
  after  :finishing,    :restart
end

# Capistrano 3
task :check_shell_type do
  on roles(:app) do
    info capture("[[ $- == *i* ]] && echo 'Interactive' || echo 'Not interactive'")
    info capture("[[ -o login ]] && echo 'Login shell' || echo 'Not login shell'")
  end
end

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
