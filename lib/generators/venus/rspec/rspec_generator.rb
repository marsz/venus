module Venus
  module Generators
    class RspecGenerator < Base
      desc "Remove test/ and build rspec"

      def asks
        @factory_girl = has_gem?('factory_girl_rails')
        @factory_girl = @factory_girl || ask?("instal factory_girl_rails", true)
        @disable_assets_generator = ask?("disable js/css generate in controller generator", true)
        @disable_helper_generator = ask?("disable helper generate in controller generator", true)
      end

      def name
        "Rspec"
      end

      def remove_test
        remove_dir "test"
      end

      def set_gemfile
        append_gem_into_group([:development, :test], "factory_girl_rails") if @factory_girl
        append_gem_into_group([:development, :test], "rspec-rails")
        append_gem_into_group([:development, :test], "rspec")
        bundle_install
        ask_bundle_update
        generate "rspec:install"
      end

      def application
        insert_template(
          "config/application.rb",
          "config_application.rb.erb",
          :after => "class Application < Rails::Application\n"
        )
      end

      def spec_helper
        to_file = "spec/spec_helper.rb"
        if has_gem?('devise')
          line = "\n  config.include Devise::TestHelpers, :type => :controller"
          insert_line_into_file(to_file, line, :after => "RSpec.configure do |config|")
        end
        insert_template(
          to_file,
          "spec_helper.rb",
          :after => "RSpec.configure do |config|"
        )
      end

      def rspec_options
        append_file(".rspec", "\n--profile")
        append_file(".rspec", "\n--format doc")
        puts "more .rspec options to see : https://www.relishapp.com/rspec/rspec-core/docs/command-line"
      end
    end
  end
end