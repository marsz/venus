module Venus
  module Generators
    class OmniauthFbGenerator < Base
      desc "Setup omniauth-fb"

      def asks
        generate 'venus:settinglogic' unless has_gem?('settingslogic')
        generate 'venus:devise' unless has_gem?('devise')
        @fb_app_id = ask("Facebook App ID? [267188576687915]")
        @fb_app_id = '267188576687915' unless @fb_app_id.present?
        @fb_secret = ask("Facebook App Secret? [84f72292e1f6b299f4a668f12ed1a7f2]")
        @fb_secret = '84f72292e1f6b299f4a668f12ed1a7f2' unless @fb_secret.present?
        @settinglogic_class = ask("Your settinglogic class name? [Setting]")
        @settinglogic_class = 'Setting' unless @settinglogic_class.present?
        @settinglogic_yml = ask("Your settinglogic yaml file? [setting.yml]")
        @settinglogic_yml = 'setting.yml' unless @settinglogic_yml.present?
      end


      def name
        "OmniauthFB"
      end

      def gemfile
        add_gem('omniauth')
        add_gem('omniauth-facebook')
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
        if ask("Run 'bundle exec rake db:migrate'? [Y/n]").downcase != 'n'
          run('bundle exec rake db:migrate')
        end
      end

    end
  end
end