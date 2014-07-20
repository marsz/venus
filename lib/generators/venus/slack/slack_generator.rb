module Venus
  module Generators
    class SlackGenerator < Base
      desc "Setup slack for capistrano"

      def name
        "slack"
      end

      def go
        ::Venus::Slack.new.generate!
      end

    end
  end
end
