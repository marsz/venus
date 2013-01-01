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
        insert_content = load_template(template_file)
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
        insert_content = load_template(template_file)
        if options[:force] == true || !file_has_content?(to_file, insert_content)
          options.delete(:force)
          append_file(to_file, insert_content)
        end
      end

      def file_has_content?(to_file, line)
        read_destanation_file(to_file).index(line)
      end

      def add_gem(gemname, options = {})
        gemfile_content = read_destanation_file("Gemfile")
        if options.is_a?(Hash)
          options = (options.size > 0 ? options.to_s[1..-2] : "")
        elsif options.is_a?(String)
          options = "'#{options}'"
        end
        options = ", #{options}" if options.size > 0
        append_file("Gemfile", "\ngem '#{gemname}'#{options}\n") unless /\ngem[ ]+['"]#{gemname}['"]/m =~ gemfile_content
      end

      def has_file?(file)
        File.exists?(File.join(destination_root, file))
      end

      def replace_in_file(relative_path, find, replace)
        contents = read_destanation_file(relative_path)
        unless contents.gsub!(find, replace)
          raise "#{find.inspect} not found in #{relative_path}"
        end
        File.open(path, "w") { |file| file.write(contents) }
      end

      def has_gem?(gemname)
        file_has_content?('Gemfile', /gem[ ]+['"]#{gemname}['"]/m)
      end

      def read_destanation_file(filepath)
        File.open(File.join(destination_root, filepath)).read
      end
      def load_template(template_file)
        template(template_file, 'tpl', :verbose => false)
        content = read_destanation_file('tpl')
        remove_file('tpl', :verbose => false)
        content
      end
    end
  end
end
