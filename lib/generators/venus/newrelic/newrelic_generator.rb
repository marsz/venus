module Venus
  module Generators
    class NewrelicGenerator < Base
      desc "Setup gem for 'newrelic'"

      def name
        "newrelic"
      end

      def asks
        @is_repository_private = ask?("Is project private", false)
        @license_key = ask?("Newrelic license key", "")
        @app_name = app_name
      end

      def gemfile
        add_gem("newrelic_rpm", "~> 3.6.5.130")
        bundle_install
      end

      def configs
        template("newrelic.yml.erb", "config/newrelic.yml")
        unless @is_repository_private
          @license_key = ""
          template("newrelic.yml.erb", "config/newrelic.yml.example")
          append_file(".gitignore", "\nconfig/newrelic.yml") unless file_has_content?(".gitignore", "config/newrelic.yml")
        end
      end

    end
  end
end
