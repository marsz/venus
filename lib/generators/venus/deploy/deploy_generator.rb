module Venus
  module Generators
    class DeployGenerator < Base
      desc "Setup gem 'capistrano' for deployment"

      def name
        "capistrano"
      end

      def asks
        @use_rvm = ask?('use rvm?', true)
        @use_assets_pipline = ask?('use assets pipline?', true)
        @use_passenger = ask?('use passenger?', true)
        @git_uri = ask?('your git repository url?', 'git@github.com:foo/myapp.git')
        @stage = ask_stage_infomation
        if ask?('has staging server?', true)
          @staging = ask_stage_infomation('staging')
        end
      end

      def gemfile
        @is_append = !file_has_content?('Gemfile','group :development do')
        if @is_append
          concat_template('Gemfile', 'gemfile.erb')
        else
          insert_template('Gemfile', 'gemfile.erb', :after => 'group :development do')
        end
        run 'bundle install'
      end

      def capify
        run 'bundle exec capify .'
      end

      def capfile
        if @use_assets_pipline
          uncomment_lines('Capfile', 'deploy/assets')
        end
      end
      
      def copy_configs
        @app_name = app_name
        @whenever = has_gem?('whenever')
        template 'deploy.erb', 'config/deploy.rb'
        template 'stage.erb', 'config/deploy/production.rb'
        if @staging
          @stage = @staging
          template 'stage.erb', 'config/deploy/staging.rb'
        end
      end

      def deploy_setup
        if ask?('setup servers deployment?', true)
          run 'bundle exec cap production deploy:setup'
          run 'bundle exec cap staging deploy:setup' if @staging
        end
      end

      private

      def ask_stage_infomation(prefix = 'production')
        stage = {}
        stage[:env] = ask?("your #{prefix} server Rails Env?", 'production')
        stage[:user] = ask?("your #{prefix} server ssh user?", 'apps')
        stage[:server] = ask?("your #{prefix} server host?", app_name+'.com')
        stage[:branch] = ask?("your git branch?", 'master')
        stage
      end
    end
  end
end