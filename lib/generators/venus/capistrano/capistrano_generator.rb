module Venus
  module Generators
    class CapistranoGenerator < Base
      desc "Setup gem 'capistrano' for deployment"

      def sidekiq
        ::Venus::Sidekiq.new.detect_capistrano
      end
      
      def name
        "capistrano"
      end

      def asks
        @middleware = ask_with_opts("rails app middleware", 1 => :passenger, 2 => :unicorn)
        @git_uri = ask?('your git repository url?', 'git@github.com:foo/myapp.git')
        @ruby_installer = ask_with_opts("ruby installer", 1 => :rbenv, 2 => :rvm, 3 => :chruby)
        @stages = { :production => ask_stage_infomation }
        if ask?('has staging server?', false)
          @stages[:staging] = ask_stage_infomation('staging')
          copy_config_staging_rb
        end
        @slack = ask?("install slack for notifying deploy message?", false)
        @deploy_rb = "config/deploy.rb"
      end

      def gemfile
        comment_lines("Gemfile", "capistrano-ext")
        comment_lines("Gemfile", "capistrano_color")
        comment_lines("Gemfile", "rvm-capistrano")
        append_gem_into_group(:development, "capistrano-#{@ruby_installer}") if @ruby_installer.present?
        append_gem_into_group(:development, 'capistrano-rails')
        add_gem("figaro") # secret key
        bundle_install
        if has_gem?("capistrano") && gem_version("capistrano").to_i < 3
          ask_bundle_update(true)
        else
          ask_bundle_update
        end
        @exists_files = ["Capfile", "config/deploy.rb", "config/deploy/production.rb", "config/deploy/staging.rb"]
        if ask?("backup exists file", true)
          @exists_files.each{ |file| cp_file(file, "#{file}.bak") }
        end
        @exists_files.each{ |file| remove_file(file) }
        bundle_exec('cap install')
      end

      def capfile
        uncomment_lines('Capfile', "require 'capistrano/#{@ruby_installer}'") if @ruby_installer.present?
        uncomment_lines('Capfile', "require 'capistrano/bundler'")
        uncomment_lines('Capfile', "require 'capistrano/rails/assets'")
        uncomment_lines('Capfile', "require 'capistrano/rails/migrations'")
      end
      
      def copy_configs
        change_config_value(@deploy_rb, "set :application", app_name)
        change_config_value(@deploy_rb, "set :repo_url", @git_uri)
        uncomment_lines(@deploy_rb, "set :scm")
        uncomment_lines(@deploy_rb, "set :linked_files")
        replace_in_file(@deploy_rb, "'config/database.yml'", "'config/database.yml', 'config/application.yml'")
        uncomment_lines(@deploy_rb, "set :linked_dirs")
        @stages.each do |stage, server|
          to_file = "config/deploy/#{stage}.rb"
          prepend_file(to_file, "set :branch, '#{server[:branch]}'\n")
          prepend_file(to_file, "set :rails_env, '#{server[:env]}'\n")
          prepend_file(to_file, "set :deploy_to, '/home/#{server[:user]}/#{app_name}'\n")
          ssh_uri = server[:user] + "@" + server[:host]
          [:app, :web, :db].each{ |role| change_config_value(to_file, "role :#{role}", [ssh_uri]) }
          comment_lines(to_file, "server 'example.com'")
        end
      end

      def gitignore
        add_gitignore("/.capistrano/*")
      end

      def secret_key_fix
        settingslogic_dependent
        settingslogic_insert("SECRET_KEY_BASE" => "12341234")
        if has_file?("config/initializers/devise.rb")
          uncomment_lines("config/initializers/devise.rb", "config.secret_key")
        end
        content = "
production:
  secret_key_base: <%= ENV[\"SECRET_KEY_BASE\"] %>"
        insert_line_into_file("config/secrets.yml", content)
        if @stages[:staging]
          content = "
#{@stages[:staging][:env]}:
  secret_key_base: <%= ENV[\"SECRET_KEY_BASE\"] %>"
          insert_line_into_file("config/secrets.yml", content)
        end
      end

      def passenger
        uncomment_lines(@deploy_rb, "execute :touch") if @middleware == :passenger
      end

      def unicorn
        if @middleware == :unicorn
          generate "venus:unicorn"
        end
      end

      def whenever
        ::Venus::Whenever.new.detect_capistrano
      end

      def sidekiq
        ::Venus::Sidekiq.new.detect_capistrano
      end

      def slack
        ::Venus::Slack.new.generate! if @slack
      end

      def says
        say "more configurations:"
        say "  1. Your exists files (#{@exists_files.join(", ")}) has backuped with .bak"
        say "  2. edit config/deploy.rb & config/deploy/production.rb to customize your deploy configuration"
        say "setup server:"
        say "  run: bundle exec cap production deploy"
      end

      private

      def change_config_value(to_file, pattern, value)
        value = case value.class.to_s
                when "String" then "'#{value}'"
                when "Array" then "%w{#{value.join(' ')}}"
                else value
                end
        replace_in_file(to_file, /#{pattern},[^\n]+\n/, "#{pattern}, #{value}\n")
      end

      def ask_stage_infomation(prefix = 'production')
        stage = {}
        stage[:env] = ask?("your #{prefix} server Rails Env?", prefix)
        stage[:user] = ask?("your #{prefix} server ssh user?", 'apps')
        stage[:host] = ask?("your #{prefix} server host?", app_name+'.com')
        stage[:branch] = ask?("your git branch?", 'master')
        stage
      end

      def copy_config_staging_rb
        unless has_file?("config/environments/staging.rb")
          cp_file("config/environments/production.rb", "config/environments/staging.rb")
        end
      end
    end
  end
end