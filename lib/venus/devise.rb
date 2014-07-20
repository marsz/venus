module Venus
  class Devise < ::Venus::Base

    def generate!(model_name = nil)
      @model_name = model_name || ask_model
      asks
      gemfile
      install
      views
      factory_girl
      messages
    end

    def ask_model
      ask?("model class?", 'User')
    end

    private

    def asks
      @views = ask?("Generate views?", false)
      if @views
        @scoped = ask?("scoped views?", false)
      end
    end

    def gemfile
      if !has_gem?('devise')
        add_gem('devise')
        bundle_install
        ask_bundle_update
      end
    end

    def install
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

    def factory_girl
      if has_gem?('factory_girl_rails') && ask?('insert code to factories', true)
        factory_girl_file = "spec/factories/#{@model_name.tableize}.rb"
        unless file_has_content?(factory_girl_file, '    password')
          insert_line_into_file(factory_girl_file, '    password "12341234"', :after => "factory :#{@model_name.underscore} do")
        end
        unless file_has_content?(factory_girl_file, 'sequence(:email)')
          insert_line_into_file(factory_girl_file, '    sequence(:email){ |n| "user#{n}@5fpro.com" }', :after => "factory :#{@model_name.underscore} do")
        end
      end
    end

    def messages
      say("remember to choose your devise modules:")
      say("  1. app/models/#{@model_name.underscore}.rb")
      say("  2. db/migrate/..._devise_create_#{@model_name.underscore.pluralize}.rb")
      say("to install omniauth:")
      say("  rails g venus:omniauth")
    end

  end
end