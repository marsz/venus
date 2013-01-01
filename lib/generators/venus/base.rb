require 'rails/generators'
require "generators/venus/helpers"
module Venus
  module Generators
    class Base < ::Rails::Generators::Base
      include Rails::Generators::ResourceHelpers
      
      include Rails::Generators::Migration
      def self.next_migration_number(path)
        Time.now.utc.strftime("%Y%m%d%H%M%S")
      end

      include Venus::Generators::Helpers

      def self.source_root
        File.expand_path(File.join(File.dirname(__FILE__), generator_name, 'templates'))
      end

    end
  end
end
