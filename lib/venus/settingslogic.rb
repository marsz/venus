module Venus
  class Settingslogic < ::Venus::Base

    def generate!
      @filename = ask?("Your yaml file name in config/ ?", 'application.yml')
      @setting_class = ask?("Your setting class name ?", 'Setting')
      add_gem('settingslogic')
      bundle_install
      template "application.yml", "config/#{@filename}"
      template "application.yml", "config/#{@filename}.example"
      add_gitignore "/config/#{@filename}"
      @setting_name = @setting_class.underscore
      template "setting.rb.erb", "app/lib/#{@setting_name}.rb"
      return [@filename, @setting_class]
    end

  end
end