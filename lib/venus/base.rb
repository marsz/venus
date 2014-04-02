module Venus
  class Base < ::Rails::Generators::Base

    include Venus::Generators::Helpers

    def self.source_root
      File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
    end


  end
end
