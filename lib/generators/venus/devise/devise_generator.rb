module Venus
  module Generators
    class DeviseGenerator < Base
      desc "Setup devise"

      def name
        "Devise"
      end

      def asks
        @views = ask?("Generate views?", false)
        @model_name = ask?("model class?", 'User')
      end

      def gemfile
        unless has_gem?('devise')
          @version = ask?('devise version?', '2.2.3')
          add_gem('devise', "~> #{@version}")
          bundle_install
        end
      end

      def generates
        generate 'devise:install'
        generate "devise #{@model_name}"
      end

      def views
        if @views
          generate 'devise:views -e erb'
        end
      end

    end
  end
end