# invest.minvoatokrazvitia.ru
server '144.76.120.175', user: 'es-test-issue', roles: %w(web app db)
set :rvm_ruby_version, '2.1.0'
set :deploy_to, '/srv/mystand/es-test-issue/repository'

namespace :unicorn do
  pid_path = "#{fetch(:deploy_to)}/shared/pids"
  unicorn_pid = "#{pid_path}/unicorn.pid"

  def run_unicorn
    within current_path do
      execute :bundle, 'exec unicorn', "-c #{release_path}/config/unicorn.rb -D -E production"
    end
  end

  desc 'Start unicorn'
  task :start do
    on roles(:app) do
      run_unicorn
    end
  end

  desc 'Stop unicorn'
  task :stop do
    on roles(:app) do
      if test "[ -f #{unicorn_pid} ]"
        execute :kill, "-QUIT `cat #{unicorn_pid}`"
      end
    end
  end

  desc 'Force stop unicorn (kill -9)'
  task :force_stop do
    on roles(:app) do
      if test "[ -f #{unicorn_pid} ]"
        execute :kill, "-9 `cat #{unicorn_pid}`"
        execute :rm, unicorn_pid
      end
    end
  end

  desc 'Restart unicorn'
  task :restart do
    on roles(:app) do
      if test "[ -f #{unicorn_pid} ]"
        execute :kill, "-USR2 `cat #{unicorn_pid}`"
      else
        run_unicorn
      end
    end
  end
end
