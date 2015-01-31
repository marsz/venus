module Venus
  class Aws < ::Venus::Base

    def generate!
      settingslogic_dependent
      if !key_in_settingslogic?("aws.access_key_id") || !key_in_settingslogic?("aws.secret_access_key")
        @aws_access_key = ask?("Your AWS access key id?", 'your_aws_acces_key_id')
        @aws_secret_key = ask?("Your AWS secret key?", 'your_aws_acces_key_secret')
        settingslogic_insert({ :aws => { :access_key_id => @aws_access_key, :secret_access_key => @aws_secret_key } }, ['aws.secret_access_key'] )
      end
      @ses = ask?("Setup SES for mailer?", true)
      add_gem('aws-sdk')
      bundle_install
      ask_bundle_update
      template 'aws.rb.erb', 'config/initializers/aws.rb'
      ses_mailer
      return [settingslogic_yml, settingslogic_class]
    end

    private

    def ses_mailer
      if @ses
        change_config_value("config/application.rb", "    config.action_mailer.delivery_method", "= :aws_ses", :after => "class Application < Rails::Application")
        insert_line_into_file("config/initializers/aws.rb", "ActionMailer::Base.default_url_options = { :host => #{settingslogic_class}.host }")
      end
    end

  end
end