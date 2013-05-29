module Venus
  module Generators
    class AssetSyncGenerator < Base
      desc "asset_sync"

      def name
        "asset_sync"
      end

      def asks
        settingslogic_dependent
        @settings = {}
        @settings[:aws_access_key_id] = ask?("AWS access key", "") unless key_in_settingslogic?("aws_access_key_id")
        @settings[:aws_secret_access_key] = ask?("AWS secret key", "") unless key_in_settingslogic?("aws_secret_access_key")
        @settings[:aws_assets_region] = ask?("AWS S3 region for assets sync", "us-east-1") unless key_in_settingslogic?("aws_assets_region")
        @settings[:aws_assets_bucket] = ask?("AWS S3 bucket for assets sync", app_name) unless key_in_settingslogic?("aws_assets_bucket")
        @settings[:aws_assets_host] = ask?("AWS S3 host for assets sync", "#{app_name}.s3-website-us-east-1.amazonaws.com") unless key_in_settingslogic?("aws_assets_host")
        @settings[:aws_assets_path_prefix] = ask?("AWS S3 assets path prefix", "") unless key_in_settingslogic?("aws_assets_path_prefix")
      end

      def set_gemfile
        add_gem("asset_sync", "~> 0.5.4")
        bundle_install
      end

      def insert_to_yaml
        Hash[@settings.to_a.reverse].each do |key, value|
          is_secret = key == :aws_secret_access_key ? true : false
          insert_settingslogics(key, value, :secret => is_secret)
        end
      end

      def production_rb
        to_file = "config/environments/production.rb"
        line = "  config.action_controller.asset_host = #{@settinglogic_class}.aws_assets_host"
        unless file_has_content?(to_file, line)
          comment_lines(to_file, /config\.action_controller\.asset_host/)
          insert_line_into_file(to_file, line, :before => /\nend[\n]*$/)
        end

        line2 = "  config.assets.prefix = #{@settinglogic_class}.aws_assets_path_prefix"
        unless file_has_content?(to_file, line2)
          comment_lines(to_file, /config\.assets\.prefix/)
          insert_line_into_file(to_file, line2, :before => /\nend[\n]*$/)
        end
      end

      def copy_initializer_file
        template 'asset_sync.rb.erb', 'config/initializers/asset_sync.rb'
      end


    end
  end
end