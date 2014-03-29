module Venus
  module Generators
    class DeviseGenerator < Base
      desc "Setup devise"

      def name
        "Devise"
      end

      def asks
        @bundle_update = ask?("bundle update devise", false)
        @model_name = ask?("model class?", 'User')
        @views = ask?("Generate views?", false)
        if @views
          @scoped = ask?("scoped views?", false)
        end
      end

      def gemfile
        if !has_gem?('devise') || @bundle_update
          add_gem('devise')
          bundle_install
          bundle_update('devise') if @bundle_update
        end
      end

      def generates
        generate 'devise:install'
        generate "devise #{@model_name}"
        if @scoped
          replace_in_file("config/initializers/devise.rb", "scoped_views = false", "scoped_views = true")
          uncomment_lines("config/initializers/devise.rb", "config.scoped_views = true")
        end
      end

      def views
        if @views
          @scoped_name = @model_name.underscore.pluralize if @scoped
          generate "devise:views #{@scoped_name}"
        end
      end

      def messages
        say("remember to choose your devise modules:")
        say("  1. app/models/#{@model_name.underscore}.rb")
        say("  2. db/migrate/..._devise_create_#{@model_name.underscore.pluralize}.rb")
      end

    end
  end
end