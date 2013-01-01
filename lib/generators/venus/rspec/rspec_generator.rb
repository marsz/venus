module Venus
  module Generators
    class RspecGenerator < Base
      desc "Remove test/ and build rspec"

      def name
        "Rspec"
      end

      def remove_test
        remove_dir "test"
      end

      def set_gemfile
        concat_template("Gemfile", "gemfile.rb")
        run "bundle install"
        generate "rspec:install"
      end

      def application
        insert_template(
          "config/application.rb",
          "config_application.rb",
          :before => "  end\n"
        )
      end

      def spec_helper
        insert_template(
          "spec/spec_helper.rb",
          "spec_helper.rb",
          :before => "\nend\n"
        )
      end

    end
  end
end