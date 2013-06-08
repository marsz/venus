module Venus
  module Generators
    class SidekiqGenerator < Base
      desc "Setup for sidekiq"

      def name
        "venus-sidekiq"
      end

      def asks
        say 'checking dependent gems "settinglogic"...'
        generate 'venus:settingslogic' unless has_gem?('settingslogic')
        @settinglogic_class = ask?("Your settinglogic class name?", 'Setting')
        @settinglogic_yml = ask?("Your settinglogic yaml file in config/ ?", 'setting.yml')

        @redis_uri = ask?("redis server uri with db", "redis://127.0.0.1:6379/0")
        @namespace = ask?("sidekiq namespace", app_name)

        if has_gem?('devise')
          @devise_scope = ask?("devise scope", "user")
          @devise_async = ask?("setup devise async", true)
        end

      end

      def gemfile
        add_gem('sidekiq', '~> 2.12.1')
        add_gem('slim')
        add_gem('sinatra', '>= 1.3.0')
        add_gem('devise-async', "~> 0.7.0") if @devise_async
        bundle_install
      end

      def settingslogic
        content = load_template("settings.erb")
        to_file = "config/#{@settinglogic_yml}"
        insert_into_setting_yml(to_file, "sidekiq", content) unless file_has_content?(to_file, "\n  sidekiq:")
        insert_into_setting_yml("#{to_file}.example", "sidekiq", content) unless file_has_content?("#{to_file}.example", "\n  sidekiq:")
      end

      def insert_initializer
        template 'sidekiq.erb', 'config/initializers/sidekiq.rb'
      end

      def routes
        unless file_has_content?("config/routes.rb", 'sidekiq/web')
          require_line = "require 'sidekiq/web'\n"
          insert_line_into_file("config/routes.rb", require_line, :before => /[A-Za-z0-9]+::Application\.routes\.draw/)
        end
        route load_template("routes.erb")
      end

      def devise_async
        if @devise_async
          insert_line_into_file("app/models/#{@devise_scope}.rb", "  devise :async\n", :after => "ActiveRecord::Base\n")
          initializer("devise_async.rb", load_template('devise_async.erb'))
        end
      end

      def capistrano
        if has_gem?('capistrano')
          content = load_template("deploy.erb")
          to_file = "config/deploy.rb"
          append_file(to_file, content) unless file_has_content?(to_file, content)
          template 'sidekiq.yml', "config/sidekiq.yml"
        end
      end

    end
  end
end
