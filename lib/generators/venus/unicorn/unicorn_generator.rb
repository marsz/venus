module Venus
  module Generators
    class UnicornGenerator < Base
      desc "Setup gem for 'unicorn'"

      def name
        "unicorn"
      end

      def asks
        generate 'venus:capistrano' if !has_gem?('capistrano') && ask?("install capistrano 3 at first", true)
        @app_path = ask?("prefix of app path", "/home/apps")
      end

      def gemfile
        add_gem("unicorn")
        bundle_install
        ask_bundle_update
      end

      def configs
        template("unicorn.rb.erb", "config/unicorn/production.rb")
        template("unicorn.rb.erb", "config/unicorn/staging.rb") if has_file?("config/environments/staging.rb")
        template("nginx.conf.erb", "config/unicorn/nginx.conf.example")
      end

      def capistrano
        ::Venus::Unicorn.new.detect_capistrano
      end

    end
  end
end
