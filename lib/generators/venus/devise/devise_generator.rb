module Venus
  module Generators
    class DeviseGenerator < Base
      desc "Setup devise"

      def name
        "Devise"
      end

      def asks
        # @fb_app_id = ask("Facebook App ID? [267188576687915]")
        # @fb_app_id = '267188576687915' unless @fb_app_id.present?
      end

      def gemfile
        add_gem('devise', "~> 2.1.2")
        run 'bundle install'
      end

      def generates
        generate 'devise:install'
        generate 'devise User'
      end

    end
  end
end