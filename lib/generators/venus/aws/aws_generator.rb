module Venus
  module Generators
    class AwsGenerator < Base
      desc "Setup gem for 'aws-sdk'"

      def name
        "AWS"
      end

      def asks
        settingslogic_dependent
        @aws_access_key = ask?("Your AWS access key id?", '') unless key_in_settingslogic?("aws.access_key_id")
        @secret_access_key = ask?("Your AWS secret key?", '') unless key_in_settingslogic?("aws.secret_access_key")
        @setup_email = ask?("Setup SES for mailer?", true)
        @bundle_update = ask?("bundle update aws-sdk", false)
      end

      def gemfile
        add_gem('aws-sdk')
        bundle_install
        bundle_update('aws-sdk') if @bundle_update
      end

      def configs
        template 'aws.rb.erb', 'config/initializers/aws.rb'
        settingslogic_insert({ :aws => { :access_key_id => @aws_access_key, :secret_access_key => @secret_access_key } }, ['aws.secret_access_key'] )
      end

      def config_application
        if @setup_email
          change_config_value("config/application.rb", "    config.action_mailer.delivery_method", "= :aws_ses", :after => "class Application < Rails::Application")
        end
      end

    end
  end
end
