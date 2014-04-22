module Venus
  module Generators
    class SidekiqGenerator < Base
      desc "Setup for sidekiq"

      def name
        "venus-sidekiq"
      end

      def asks
        settingslogic_dependent

        @redis_uri = ask?("redis url", "redis://127.0.0.1:6379/0")
        @namespace = ask?("sidekiq namespace", app_name)
        @web_monitoring = ask?("web page monitoring")

        if has_gem?('devise')
          @devise_async = ask?("setup devise async", true)
          @devise_scope = ask?("devise model name", "user") if @devise_async
        end

      end

      def gemfile
        add_gem('sidekiq')
        add_gem('sinatra') if @web_monitoring
        add_gem('devise-async') if @devise_async
        bundle_install
        ask_bundle_update
      end

      def settingslogic
        settingslogic_insert(:sidekiq => { :redis => @redis_uri, :namespace => @namespace } )
      end

      def insert_configs
        template 'sidekiq.erb', 'config/initializers/sidekiq.rb'
        template 'sidekiq.yml', 'config/sidekiq.yml'
      end

      def devise_async
        if @devise_async
          insert_line_into_file("app/models/#{@devise_scope}.rb", "  devise :async\n", :after => "ActiveRecord::Base\n")
          initializer("devise_async.rb", load_template('devise_async.erb'))
        end
      end

      def web_monitoring
        if @web_monitoring
          unless file_has_content?("config/routes.rb", 'sidekiq/web')
            require_line = "require 'sidekiq/web'\n"
            insert_line_into_file("config/routes.rb", require_line, :before => /\.routes\.draw/)
          end
          route "mount Sidekiq::Web => '/sidekiq'"
          say "to see more web setup: https://github.com/mperham/sidekiq/wiki/Monitoring"
        end
      end
      
      def capistrano
        ::Venus::Sidekiq.new.detect_capistrano
      end
    end
  end
end
