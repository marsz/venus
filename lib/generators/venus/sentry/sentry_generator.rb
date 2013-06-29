module Venus
  module Generators
    class SentryGenerator < Base
      desc "Setup sentry for cloud exceptions"

      def name
        "sentry"
      end

      def asks
        settingslogic_dependent
        @dsn = ask?("DSN in sentry", "")
      end

      def settings
        unless key_in_settingslogic?("sentry_dsn")
          insert_settingslogics("sentry_dsn", @dsn, :secret => true)
        end
      end

      def gemfile
        add_gem("sentry-raven", "~> 0.4.8")
        bundle_install
      end

      def configs
        template("raven.erb", "config/initializers/raven.rb")
        @js_template = "<%= #{@settinglogic_class}.sentry_dsn rescue nil %>"
        template("js.erb", "app/views/application/raven.erb")
        say "render partial 'raven' for logging js exceptions"
      end

    end
  end
end
