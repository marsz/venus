module Venus
  module Generators
    class HipchatGenerator < Base
      desc "Setup hipchat"

      def name
        "hipchat"
      end

      def asks
        @is_repository_private = ask?("Is project private", false)
        settingslogic_dependent unless @is_repository_private
        @token = ask?("HipChat API token", "")
        @room = ask?("HipChat room for deploy notification", "")
      end

      def settings
        unless @is_repository_private
          insert_settingslogics("hipchat_token", @token, :secret => true) unless key_in_settingslogic?("hipchat_token")
          insert_settingslogics("hipchat_room", @room) unless key_in_settingslogic?("hipchat_room")
        end
      end

      def gemfile
        add_gem("hipchat", "~> 0.10.0")
        bundle_install
      end

      def configs
        concat_template("config/deploy.rb", "deploy.rb.erb")
      end

    end
  end
end
