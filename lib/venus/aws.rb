module Venus
  class Aws < ::Venus::Base

    def generate!
      settingslogic_dependent
      if !key_in_settingslogic?("aws.access_key_id") || !key_in_settingslogic?("aws.secret_access_key")
        @aws_access_key = ask?("Your AWS access key id?", '') unless 
        @aws_secret_key = ask?("Your AWS secret key?", '') unless 
        settingslogic_insert({ :aws => { :access_key_id => @aws_access_key, :secret_access_key => @aws_secret_key } }, ['aws.secret_access_key'] )
      end
      add_gem('aws-sdk')
      bundle_install
      ask_bundle_update
      template 'aws.rb.erb', 'config/initializers/aws.rb'
      return [settingslogic_yml, settingslogic_class]
    end

  end
end