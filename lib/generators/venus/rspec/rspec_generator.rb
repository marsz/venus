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
        line = '  config.include Devise::TestHelpers, :type => :controller'
        inset_line_into_file(line, to_file, :before => "\nend\n") if has_gem?('devise')
      end

    end
  end
end