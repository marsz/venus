module Venus
  class Whenever < ::Rails::Generators::Base

    include Venus::Generators::Helpers

    def detect_capistrano
      if has_gem?("whenever") && (has_gem?("capistrano") || has_gem?("capistrano-rails"))
        if ask?("install whenever-capistrano?")
          say "bundle update whenever"
          bundle_update("whenever")
          if gem_version("capistrano").to_i >= 3
            capistrano_3
          else
            capistrano_2
          end
        end
      end
    end

    private

    def capistrano_3
      insert_line_into_file("Capfile", "require 'whenever/capistrano'")
      insert_line_into_file("config/deploy.rb", "set :whenever_roles, ->{ :db }")
      insert_line_into_file("config/deploy.rb", "# more whenever config in https://github.com/javan/whenever/blob/master/lib/whenever/capistrano/v3/tasks/whenever.rake")
    end

    def capistrano_2
      insert_line_into_file("config/deploy.rb", "set :whenever_command, 'bundle exec whenever'")
      insert_line_into_file("config/deploy.rb", "set :whenever_roles, [:db]")
      insert_line_into_file("config/deploy.rb", "require 'whenever/capistrano'")
    end

  end
end