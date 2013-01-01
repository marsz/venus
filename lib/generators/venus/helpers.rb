module Venus
  module Generators
    module Helpers

      private

      def ask?(message, default_ans = true)
        postfix = " [" + (!!default_ans == default_ans ? (default_ans ? 'Y/n' : 'y/N') : default_ans.to_s) + "]"
        ans = ask("#{message}#{postfix}")
        return (ans.present? ? (['n','N'].include?(ans) ? false : ans) : default_ans)
      end

      def read_destanation_file(filepath)
        File.open(File.join(destination_root, filepath)).read
      end

      def file_has_content?(to_file, line)
        read_destanation_file(to_file).index(line)
      end

      def has_gem?(gemname)
        file_has_content?('Gemfile', /gem[ ]+['"]#{gemname}['"]/m)
      end

      def has_file?(file)
        File.exists?(File.join(destination_root, file))
      end

      def load_template(template_file)
        template(template_file, 'tpl', :verbose => false)
        content = read_destanation_file('tpl')
        remove_file('tpl', :verbose => false)
        content
      end

      def add_gem(gemname, options = {})
        if options.is_a?(Hash)
          options = (options.size > 0 ? options.to_s[1..-2] : "")
        elsif options.is_a?(String)
          options = "'#{options}'"
        end
        options = ", #{options}" if options.size > 0
        append_file("Gemfile", "\ngem '#{gemname}'#{options}\n") unless has_gem?(gemname)
      end


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

      def replace_in_file(destanation_file, find, replace)
        contents = read_destanation_file(destanation_file)
        unless contents.gsub!(find, replace)
          raise "#{find.inspect} not found in #{destanation_file}"
        end
        File.open(destanation_file, "w") { |file| file.write(contents) }
      end

      def add_gitignore(line)
        if has_file?(".gitignore") && !file_has_content?(".gitignore", line)
          insert_line_into_file ".gitignore", line 
        end
      end

      # copy from Rails::Generators::AppGenerator
      def app_name
        File.basename(destination_root)
      end

    end
  end
end