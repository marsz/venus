module Venus
  class Sidekiq < ::Venus::Base

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

      template("sidekiq.cap", "lib/capistrano/tasks/sidekiq.cap")
    end

  end
end