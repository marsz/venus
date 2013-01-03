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

        @providers = {}
        [:facebook, :github, :twitter].each do |provider|
          if ask?("Use '#{provider}'?", true)
            token = ask?("#{provider.capitalize} App ID?", '012345678987654')
            secret = ask?("#{provider.capitalize} App Secret?", '1a2b3c4d5e6f7g8h9i12345678987654')
            @providers[provider] = {:token => token, :secret => secret}
          end
        end
      end

      def gemfile
        add_gem('omniauth')
        @providers.each do |provider, |
          add_gem("omniauth-#{provider}")
        end
      end

      def controller
        template 'omniauth_callbacks_controller.rb', 'app/controllers/users/omniauth_callbacks_controller.rb', :force => true
      end

      def routes
        file = 'config/routes.rb'
        find = 'devise_for :users'
        replace = 'devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }'
        replace_in_file(file, find, replace) if file_has_content?(file, find)
      end

      def model
        generate "model authorization provider:string uid:string user_id:integer token:string secret:string"
        template 'omniauth_callback.rb.erb', 'app/models/user/omniauth_callback.rb', :force => true
        insert_template("app/models/user.rb", "user.erb", :before => "\nend\n")
        insert_template("app/models/authorization.rb", "authorization.rb", :after => "Base\n")
        replace_in_file("app/models/user.rb", "  devise ", "  devise :omniauthable, ")
      end

      def config
        ["config/#{@settinglogic_yml}", "config/#{@settinglogic_yml}.example"].each do |to_file|
          insert_template(to_file, "setting.yml.erb", :after => "&defaults\n")
        end
        insert_template("config/initializers/devise.rb", "devise.rb.erb", :before => "\nend")
      end

      def msg
        bundle_exe('rake db:migrate') if ask?("Run 'bundle exec rake db:migrate'?", true)
      end
    end
  end
end
