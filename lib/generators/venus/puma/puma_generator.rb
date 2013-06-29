module Venus
  module Generators
    class PumaGenerator < Base
      desc "Setup gem for 'puma'"

      def name
        "puma"
      end

      def asks
        say 'checking dependent gems "capistrnano"...'
        generate 'venus:deploy' unless has_gem?('capistrano')
        @app_name = app_name
        @rails_env = "production"
      end

      def gemfile
        add_gem("puma", "~> 2.1.1")
        bundle_install
      end

      def configs
        template("nginx.conf.erb", "config/puma/nginx.conf.example")
        template("config.erb", "config/puma.rb")
        concat_template("config/deploy.rb", "deploy.rb.erb") unless file_has_content?("config/deploy.rb", load_template("deploy.rb.erb"))
      end

    end
  end
end
