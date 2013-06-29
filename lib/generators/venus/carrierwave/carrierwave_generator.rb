module Venus
  module Generators
    class CarrierwaveGenerator < Base
      desc "Setup gem 'carrierwave'"

      def name
        "carrierwave"
      end

      def asks
        @rails_version = ask?("your rails version?", '3.2')
        @rails_version = @rails_version.index("3.2") == 0 ? '3.2' : '3.1'
        @imagemagick = ask?("Use imagemagick to resize picture?", true)
        @carrierwave_meta = ask?("Install gem 'carrierwave-meta'", true)
        @sample_uploader = ask?("Generate sample uploader?", 'venus')
        @fog = ask?("Use fog to upload file to AWS S3", true)
        if @fog
          say 'checking dependent gems "settinglogic"...'
          generate 'venus:settingslogic' unless has_gem?('settingslogic')
          @settinglogic_class = ask?("Your settinglogic class name?", 'Setting')
          @settinglogic_yml = ask?("Your settinglogic yaml file in config/ ?", 'setting.yml')
          say 'checking dependent gems "aws-sdk"...'
          generate 'venus:aws' unless has_gem?('aws-sdk')
        end
      end

      def gemfile
        if @rails_version == '3.2'
          add_gem("carrierwave", "~> 0.8.0")
        else
          add_gem("carrierwave", "0.7.1")
        end
        add_gem('mini_magick', "~> 3.6.0") if @imagemagick
        add_gem("carrierwave-meta", '~> 0.0.4') if @carrierwave_meta
        add_gem('fog') if @fog
        bundle_install
      end

      def configs
        template "carrierwave_#{@rails_version}.erb", 'config/initializers/carrierwave.rb'
        if @fog
          ["config/#{@settinglogic_yml}", "config/#{@settinglogic_yml}.example"].each do |to_file|
            insert_into_setting_yml(to_file, 'aws_access_key_id', :ask, :hide_in_example => true)
            insert_into_setting_yml(to_file, 'aws_secret_access_key', :ask, :hide_in_example => true)
            @aws_bucket_carrierwave = insert_into_setting_yml(to_file, 'aws_bucket_carrierwave', @aws_bucket_carrierwave || :ask)
            @aws_region_carrierwave = insert_into_setting_yml(to_file, 'aws_region_carrierwave', @aws_region_carrierwave || :ask, :hint => "us-east-1")
            @aws_host_carrierwave = insert_into_setting_yml(to_file, 'aws_host_carrierwave', @aws_host_carrierwave || :ask, :hint => "http://example.com")
          end
        end
      end

      def sample_uploader
        template "uploader.erb", "app/uploaders/#{@sample_uploader}_uploader.rb"
      end

      def seemore
        puts "see more configuration in https://github.com/jnicklas/carrierwave"
      end

    end
  end
end
