# config valid only for Capistrano 3.1
lock '3.4.0'

set :application, 'es-test-issue'
set :repo_url, 'git@github.com:lxkuz/es-test-issue.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default value for :scm is :git
set :scm, :git

set :whenever_identifier, -> { "#{fetch(:application)}_production" }

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

set :linked_files, %w(config/database.yml config/unicorn.rb config/secrets.yml)

set :linked_dirs, %w(log public/assets public/uploads public/cache)

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :rvm_type, :system
set :rvm_ruby_version, '2.1.0'
# set :bundle_path, -> { shared_path.join('bundle') }  # this is default

namespace :deploy do

  desc 'Seed the database.'
  task :seed do
    on roles(:app) do
      within "#{current_path}" do
        with rails_env: :production do
          execute :rake, 'db:seed'
        end
      end
    end
  end

  desc 'Restart application'
  task :restart do
    invoke 'unicorn:restart'
  end

  after :publishing, :seed
  after :seed, :finishing
  after :finishing, :restart
end