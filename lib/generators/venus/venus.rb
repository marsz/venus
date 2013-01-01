require 'rails/generators'
module Venus
  module Generators
    class Base < ::Rails::Generators::Base
      include Rails::Generators::ResourceHelpers
      include Rails::Generators::Migration
      def self.next_migration_number(path)
        Time.now.utc.strftime("%Y%m%d%H%M%S")
      end
      # include Venus::Generators::Helpers

      def self.source_root
        File.expand_path(File.join(File.dirname(__FILE__), generator_name, 'templates'))
      end

      private

      def insert_template(to_file, template_file, options = {})
        insert_content = File.open(find_in_source_paths(template_file)).read
        if options[:force] == true || !file_has_content?(to_file, insert_content)
          options.delete(:force)
          inject_into_file(to_file,insert_content,options)
        end
      end

      def insert_line_into_file(to_file, line, options = {})
        if options[:force] == true || !file_has_content?(to_file, line)
          options.delete(:force)
          if(options[:after] || options[:before])
            inject_into_file(to_file, "\n#{line}\n", options)
          else
            append_file(to_file, "\n#{line}")
          end
        end
      end

      def concat_template(to_file, template_file, options = {})
        insert_content = File.open(find_in_source_paths(template_file)).read
        if options[:force] == true || !file_has_content?(to_file, insert_content)
          options.delete(:force)
          append_file(to_file, insert_content)
        end
      end

      def file_has_content?(to_file, line)
        File.open(File.join(destination_root,to_file)).read.index(line)
      end

      def add_gem(gemname, options = {})
        gemfile_content = File.open(File.join(destination_root, "Gemfile")).read
        options = (options.size > 0 ? (", "+options.to_s[1..-2]) : "")
        append_file("Gemfile", "\ngem '#{gemname}#{options}'\n") unless /\ngem[ ]+['"]#{gemname}['"]/m =~ gemfile_content
      end

      def has_file?(file)
        File.exists?(File.join(destination_root, file))
      end
    end
  end
end
