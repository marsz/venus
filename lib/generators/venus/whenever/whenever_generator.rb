module Venus
  module Generators
    class WheneverGenerator < Base
      desc "Setup gem 'whenever' for scheduling"

      def name
        "Whenever"
      end

      def asks
      end

      def gemfile
        add_gem('whenever')
        bundle_install
        bundle_exec('wheneverize .')
      end

      def capistrano
        ::Venus::Whenever.new.detect_capistrano
      end

    end
  end
end