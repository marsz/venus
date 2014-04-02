module Venus
  module Generators
    class CarrierwaveGenerator < Base
      desc "Setup gem 'carrierwave'"

      def name
        "carrierwave"
      end

      def asks
        @fog = ask?("Use fog to upload file to AWS S3", true)
        if @fog
          aws_dependent
          @data = {}
          @data[:region] = ask?("S3 region", "us-east-1")
          @data[:bucket] = ask?("S3 bucket", "")
          @data[:host] = ask?("assets_host", "#{@data[:bucket]}.s3-website-#{@data[:region]}.amazonaws.com")
          settingslogic_insert({ :carrierwave => @data })
        end
      end

      def gemfile
        add_gem("carrierwave")
        add_gem('mini_magick')
        add_gem('fog') if @fog
        bundle_install
        ask_bundle_update
      end

      def configs
        template "carrierwave.rb.erb", 'config/initializers/carrierwave.rb'
        unless @fog
          comment_lines('config/initializers/carrierwave.rb', "\n")
          comment_lines('config/initializers/carrierwave.rb', "CarrierWave.configure")
        end
      end

      def sample_uploader
        generate "uploader venus"
        uploader = "app/uploaders/venus_uploader.rb"
        uncomment_lines(uploader, "CarrierWave::MiniMagick")
        if @fog
          comment_lines(uploader, "storage :file")
          uncomment_lines(uploader, "storage :fog")
        end
        insert_template(uploader, "uploader.erb", :before => "\nend")
      end

      def seemore
        say "see more configuration in https://github.com/jnicklas/carrierwave"
      end

    end
  end
end
