module Venus
  module Generators
    class AssetSyncGenerator < Base
      desc "asset_sync"

      def name
        "asset_sync"
      end

      def go
        asks
        gemfile
        config_files
      end

      private

      def asks
        @provider = ask_with_opts("fog provider", { 1 => 'AWS', 2 => 'Rackspace', 3 => 'Google'}, 1)
        @assets_host = "localhost:3000"
        if @provider == 'AWS'
          @asset_sync = {
            :bucket => ask?("S3 bucket", ''),
            :region => ask?("S3 region", 'us-east-1'),
            :aws_access_key_id => ask?("AWS aws access key id", ''),
            :aws_secret_access_key => ask?("AWS secret access key", '')
          }
        elsif @provider == 'Rackspace'
          @asset_sync = {
            :bucket => ask?("Rackspace bucket", ''),
            :rackspace_username => ask?('Rackspace user name', ''),
            :rackspace_api_key => ask?('Rackspace api key', '')
          }
        elsif @provider == 'Google'
          @asset_sync = {
            :bucket => ask?("Google Storage bucket", ''),
            :google_storage_access_key_id => ask?('Google Storage api key', ''),
            :google_storage_secret_access_key => ask?('Google Storage secret key', '')
          }
        else
          settingslogic_dependent
        end
        @assets_prefix = "/assets"
      end

      def gemfile
        add_gem("asset_sync")
        bundle_install
        ask_bundle_update
      end

      def config_files
        # settingslogic yml
        data = { :assets_host => @assets_host, :assets_prefix => @assets_prefix }
        data[:asset_sync] = @asset_sync
        settingslogic_insert(data)
        # asset_sync
        asset_sync_file = 'config/initializers/asset_sync.rb'
        template 'asset_sync.rb.erb', asset_sync_file
        if @provider == 'AWS'
          uncomment_lines(asset_sync_file, "config.fog_region")
          uncomment_lines(asset_sync_file, "config.aws_access_key_id")
          uncomment_lines(asset_sync_file, "config.aws_secret_access_key")
        elsif @provider == 'Rackspace'
          uncomment_lines(asset_sync_file, "config.rackspace_username")
          uncomment_lines(asset_sync_file, "config.rackspace_api_key")
        elsif @provider == 'Google'
          uncomment_lines(asset_sync_file, "config.google_storage_access_key_id")
          uncomment_lines(asset_sync_file, "config.google_storage_secret_access_key")
        end

        # evn configs
        Dir.glob("#{destination_root}/config/environments/*.rb").each do |file|
          to_file = file.gsub(destination_root+"/", "")
          next if to_file =~ /test\.rb/
          change_config_value(to_file, "config.action_controller.asset_host", "= ->(source, request){ #{settingslogic_class}.assets_host }", :before => "\nend")
          change_config_value(to_file, "config.assets.prefix", "= #{settingslogic_class}.assets_prefix", :before => "\nend")
          uncomment_lines(to_file, "config.action_controller.asset_host")
          uncomment_lines(to_file, "config.assets.prefix")
        end
        
      end

    end
  end
end