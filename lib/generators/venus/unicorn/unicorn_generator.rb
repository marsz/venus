module Venus
  module Generators
    class UnicornGenerator < Base
      desc "Setup gem for 'unicorn'"

      def name
        "unicorn"
      end

      def asks
        say 'checking dependent gems "capistrnano"...'
        generate 'venus:deploy' unless has_gem?('capistrano')
        @app_name = app_name
        @rails_env = "production"
      end

      def gemfile
        append_gem_into_group("development", "capistrano-unicorn", :require => false)
        add_gem("unicorn", "~> 4.6.3")
        bundle_install
      end

      def configs
        template("unicorn.rb.erb", "config/unicorn/production.rb")
        if has_file?("config/environments/staging.rb")
          @rails_env = "staging"
          template("unicorn.rb.erb", "config/unicorn/staging.rb")
        end

        template("nginx.conf.erb", "config/unicorn/nginx.conf.example")

        concat_template("config/deploy.rb", "deploy.rb.erb")
      end

    end
  end
end
