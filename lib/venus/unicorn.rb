module Venus
  class Unicorn < ::Venus::Base

    def detect_capistrano
      if has_gem?("unicorn") && (has_gem?("capistrano") || has_gem?("capistrano-rails"))
        capistrano3_dependent
        install_capistrano3_unicorn
      end
    end

    private

    def install_capistrano3_unicorn
      append_gem_into_group("development", "capistrano3-unicorn")
      bundle_install
      bundle_update(["capistrano3-unicorn"]) if ask?("bundle update capistrano3-unicorn", false)

      insert_line_into_file("Capfile", "require 'capistrano3/unicorn'")
      insert_line_into_file("Capfile", "# require 'capistrano/sidekiq/monit' #to require monit tasks (V0.2.0+)")

      deploy_rb = "config/deploy.rb"
      template("unicorn.cap", "lib/capistrano/tasks/unicorn.rake")

      insert_line_into_file(deploy_rb, "  after :publishing, :restart", :before => "task :restart do")
      insert_line_into_file(deploy_rb, "    invoke 'unicorn:restart'", :after => "task :restart do")

    end

  end
end