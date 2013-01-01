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
        to_file = "spec/spec_helper.rb"
        insert_template(
          to_file,
          "spec_helper.rb",
          :before => "\nend\n"
        )
        if has_gem?('devise')
          line = '  config.include Devise::TestHelpers, :type => :controller'
          insert_line_into_file(to_file, line, :before => "\nend\n")
        end
      end

    end
  end
end