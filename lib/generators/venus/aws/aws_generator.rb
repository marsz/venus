module Venus
  module Generators
    class AwsGenerator < Base
      desc "Setup gem for 'aws-sdk'"

      def name
        "AWS"
      end

      def asks
        settingslogic_dependent

        @aws_access_key = ask?("Your AWS access key id?", '') unless key_in_settingslogic?("aws_access_key_id")
        @aws_access_secret = ask?("Your AWS secret access key?", '') unless key_in_settingslogic?("aws_secret_access_key")

        @setup_email = ask?("Setup SES for mailer?", true)
      end

      def gemfile
        add_gem('aws-sdk')
        bundle_install
      end

      def configs
        template 'aws.rb.erb', 'config/initializers/aws.rb'
        if @aws_access_key
          ["config/#{@settinglogic_yml}", "config/#{@settinglogic_yml}.example"].each do |to_file|
            insert_template(to_file, "setting.yml.erb", :after => "&defaults\n")
          end
        end
      end

      def config_application
        insert_template(
          "config/application.rb",
          "config_application.rb.erb",
          :before => "  end\n"
        )
      end

    end
  end
end
