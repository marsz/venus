module Venus
  module Generators
    class SettingslogicGenerator < Base
      desc "Install gem settinglogic"

      def asks
        @filename = ask?("Your yaml file name in config/ ?", 'setting.yml')
        @setting_class = ask?("Your setting class name ?", 'Setting')
      end

      def name
        "Settinglogic"
      end

      def gemfile
        add_gem('settingslogic')
        run "bundle install"
      end

      def config
        template "setting.yml", "config/#{@filename}"
        template "setting.yml", "config/#{@filename}.example"
        insert_line_into_file ".gitignore", "/config/#{@filename}" if has_file?(".gitignore")
      end

      def class_file
        @setting_name = @setting_class.underscore
        template "setting.erb", "app/lib/#{@setting_name}.rb"
      end

    end
  end
end