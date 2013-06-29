module Venus
  module Generators
    class BetterErrorsGenerator < Base
      desc "Setup better errors"

      def name
        "better_error"
      end

      def asks
        # @sublime = ask?("Use Sublime Text")
      end

      def gemfile
        append_gem_into_group("development", "better_errors")
        # append_gem_into_group("development", "binding_of_caller") if @sublime
        bundle_install
      end

      def sublime
        # template("better_errors.erb", "config/initializers/better_errors.rb") if @sublime
        # say "Download sublime-handler (https://github.com/asuth/subl-handler) to open subl:// protocol" if @sublime
      end

    end
  end
end
