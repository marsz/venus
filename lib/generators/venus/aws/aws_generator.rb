module Venus
  module Generators
    class AwsGenerator < Base
      desc "Setup gem for 'aws-sdk'"

      def name
        "AWS"
      end

      def asks
        say 'checking dependent gems "settinglogic"...'
        generate 'venus:settingslogic' unless has_gem?('settingslogic')

        @settinglogic_class = ask?("Your settinglogic class name?", 'Setting')
        @settinglogic_yml = ask?("Your settinglogic yaml file in config/ ?", 'setting.yml')

        @aws_access_key = ask?("Your AWS access key id?", '')
        @aws_access_secret = ask?("Your AWS secret access key?", '')

        @setup_email = ask?("Setup SES for mailer?", true)
      end

      def gemfile
        add_gem('aws-sdk')
        bundle_install
      end

      def configs
        template 'aws.rb.erb', 'config/initializers/aws.rb'
        ["config/#{@settinglogic_yml}", "config/#{@settinglogic_yml}.example"].each do |to_file|
          insert_template(to_file, "setting.yml.erb", :after => "&defaults\n")
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
