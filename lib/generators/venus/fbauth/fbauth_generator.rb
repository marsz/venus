module Venus
  module Generators
    class FbauthGenerator < Base
      desc "Setup gem 'omniauth-fb'"

      def asks
        say 'checking dependent gems "settinglogic"...'
        generate 'venus:settingslogic' unless has_gem?('settingslogic')
        say 'checking dependent gems "devise"...'
        generate 'venus:devise' unless has_gem?('devise')
        @fb_app_id = ask?("Facebook App ID?", '267188576687915')
        @fb_secret = ask?("Facebook App Secret?", '84f72292e1f6b299f4a668f12ed1a7f2')
        @settinglogic_class = ask?("Your settinglogic class name?", 'Setting')
        @settinglogic_yml = ask?("Your settinglogic yaml file in config/ ?", 'setting.yml')
      end

      def name
        "Omniauth FB"
      end

      def gemfile
        add_gem('omniauth')
        add_gem('omniauth-facebook')
        bundle_install
      end

      def controller
        generate "controller sessions"
        template 'sessions_controller.rb', 'app/controllers/sessions_controller.rb', :force => true
      end

      def routes
        insert_template("config/routes.rb", "routes.rb", :after => "routes.draw do\n")
      end

      def model
        migration_template "migration.rb", "db/migrate/add_columns_for_fblogin_to_users"
        insert_template("app/models/user.rb", "user.rb", :before => "\nend\n")
        replace_in_file("app/models/user.rb", "  attr_accessible ", "  attr_accessible :name, :facebook_id, ")
      end

      def config
        template 'omniauth.erb', 'config/initializers/omniauth.rb'
        ["config/#{@settinglogic_yml}", "config/#{@settinglogic_yml}.example"].each do |to_file|
          replace_in_file(to_file, "facebook_app_id: ", "facebook_app_id: '#{@fb_app_id}'")
          replace_in_file(to_file, "facebook_secret: ", "facebook_secret: '#{@fb_secret}'")
        end
      end

      def msg
        bundle_exec('rake db:migrate') if ask?("Run 'bundle exec rake db:migrate'?", true)
      end

    end
  end
end