module Venus
  module Generators
    class AwsGenerator < Base
      desc "Setup gem for 'aws-sdk'"

      def name
        "AWS"
      end

      def asks
        aws_dependent
        if ask?("Setup SES for mailer?", true)
          change_config_value("config/application.rb", "    config.action_mailer.delivery_method", "= :aws_ses", :after => "class Application < Rails::Application")
          insert_line_into_file("config/initializers/aws.rb", "ActionMailer::Base.default_url_options = { :host => #{settingslogic_class}.host }")
        end
      end

    end
  end
end
