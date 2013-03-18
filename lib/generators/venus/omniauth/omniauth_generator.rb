module Venus
  module Generators
    class OmniauthGenerator < Base
      desc "Setup gem 'omniauth' with multi providers"

      def name
        "Omniauth"
      end

      def asks
        say 'checking dependent gems "settinglogic"...'
        generate 'venus:settingslogic' unless has_gem?('settingslogic')
        say 'checking dependent gems "devise"...'
        generate 'venus:devise' unless has_gem?('devise')

        @settinglogic_class = ask?("Your settinglogic class name?", 'Setting')
        @settinglogic_yml = ask?("Your settinglogic yaml file in config/ ?", 'setting.yml')
        @devise_model = ask?("Devise model name?", 'User')
        @devise_scope = @devise_model.underscore
        @devise_table = @devise_model.tableize
        @providers = {}
        [:facebook, :github, :twitter].each do |provider|
          if ask?("Use '#{provider}'?", true)
            token = ask?("#{provider.capitalize} App ID?", '267188576687915')
            secret = ask?("#{provider.capitalize} App Secret?", '84f72292e1f6b299f4a668f12ed1a7f2')
            @providers[provider] = {:token => token, :secret => secret}
          end
        end
      end

      def gemfile
        add_gem('omniauth')
        @providers.each do |provider, |
          add_gem("omniauth-#{provider}")
        end
        bundle_install
      end

      def controller
        template 'omniauth_callbacks_controller.rb.erb', "app/controllers/#{@devise_table}/omniauth_callbacks_controller.rb", :force => true
      end

      def configs
        insert_template('config/routes.rb', 'routes.erb', :after => "routes.draw do\n")
        template 'omniauth.rb.erb', 'config/initializers/omniauth.rb'
        ["config/#{@settinglogic_yml}", "config/#{@settinglogic_yml}.example"].each do |to_file|
          insert_template(to_file, "setting.yml.erb", :after => "&defaults\n")
        end
      end

      def model
        generate "model authorization provider:string uid:string auth_type:string auth_id:integer auth_data:text"
        insert_template 'app/models/authorization.rb', 'authorization.rb', :after => "ActiveRecord::Base\n"
        template 'omniauthable.rb', 'app/lib/omniauthable.rb'
        insert_template("app/models/#{@devise_scope}.rb", "user.erb", :before => "\nend\n")
        sleep(1)
        migration_template "migrations.rb.erb", "db/migrate/add_index_for_authorizations_and_add_column_for_#{@devise_table}"
      end

      def msg
        bundle_exec('rake db:migrate') if ask?("Run 'bundle exec rake db:migrate'?", true)
      end
    end
  end
end
