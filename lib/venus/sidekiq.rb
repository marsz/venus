module Venus
  class Sidekiq < ::Rails::Generators::Base

    include Venus::Generators::Helpers

    def detect_capistrano
      return if has_gem?("capistrano-sidekiq")
      if has_gem?("sidekiq") && (has_gem?("capistrano") || has_gem?("capistrano-rails"))
        is_cap3 = gem_version("capistrano").to_i >= 3
        if is_cap3 && ask?("install sidekiq-capistrano?")
          install_capistrano_sidekiq
        end
      end
    end

    private

    def install_capistrano_sidekiq
      add_gem("capistrano-sidekiq")
      bundle_install
      bundle_update(["capistrano-sidekiq"])
      insert_line_into_file("Capfile", "require 'capistrano/sidekiq'")
      insert_line_into_file("Capfile", "# require 'capistrano/sidekiq/monit' #to require monit tasks (V0.2.0+)")

      insert_line_into_file("config/deploy.rb", "\n# sidekiq options")
      insert_line_into_file("config/deploy.rb", "set :sidekiq_default_hooks, -> { true }")
      insert_line_into_file("config/deploy.rb", "set :sidekiq_pid,           -> { File.join(shared_path, 'tmp', 'pids', 'sidekiq.pid') }")
      insert_line_into_file("config/deploy.rb", "set :sidekiq_env,           -> { fetch(:rack_env, fetch(:rails_env, fetch(:stage))) }")
      insert_line_into_file("config/deploy.rb", "set :sidekiq_log,           -> { File.join(shared_path, 'log', 'sidekiq.log') }")
      insert_line_into_file("config/deploy.rb", "set :sidekiq_timeout,       -> { 10 }")
      insert_line_into_file("config/deploy.rb", "set :sidekiq_role,          -> { :app }")
      insert_line_into_file("config/deploy.rb", "set :sidekiq_processes,     -> { 1 }")
    end

  end
end