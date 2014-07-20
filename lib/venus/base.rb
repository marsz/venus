module Venus
  class Base < ::Rails::Generators::Base
    
    include Rails::Generators::Migration
    def self.next_migration_number(path)
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    end

    include Venus::Generators::Helpers

    def self.source_root
      File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
    end


  end
end
