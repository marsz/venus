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
        file_has_content?('Gemfile.lock', / #{gemname} \(/m)
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

      def bundle_install
        Bundler.with_clean_env do
          run "bundle install"
        end
      end

      def bundle_exec(exec)
        Bundler.with_clean_env do
          run "bundle exec #{exec}"
        end
      end

      def js_assets_require(js_file, required_file, options = {})
        to_file = "app/assets/javascripts/#{js_file}"
        line = "//= require #{required_file}"
        if file_has_content?(to_file, "//= require_self")
          opts = { :before => "//= require_self" }
        else
          after = "//= require jquery_ujs"
          after = "// GO AFTER THE REQUIRES BELOW." unless file_has_content?(to_file, after)
          opts = { :after => after }
        end
        insert_line_into_file(to_file, line, opts.merge(options))
      end

      def css_assets_require(css_file, required_file, options = {})
        to_file = "app/assets/stylesheets/#{css_file}"
        line = " *= require #{required_file}"
        if file_has_content?(to_file, " *= require_self")
          opts = { :before => " *= require_self" }
        else
          after = " * compiled file, but it's generally better to create a new file per style scope."
          after = "/*" unless file_has_content?(to_file, after)
          opts = { :after => after}
        end
        insert_line_into_file(to_file, line, opts.merge(options))
      end

      def insert_js_template(js_file, template_file, options = {})
        line = "//= require_self"
        to_file = "app/assets/javascripts/#{js_file}"
        after = "//= require jquery_ujs"
        after = "//= require_tree .\n" if file_has_content?(to_file, "//= require_tree .\n")
        opts = { :after => after }.merge(options)
        insert_line_into_file(to_file, line, opts)
        concat_template(to_file, template_file, options)
      end

      def insert_into_setting_yml(to_file, key, value, opts = {})
        unless file_has_content?(to_file, "  #{key}:")
          value = '' if opts[:hide_in_example] && to_file.index('.example')
          value = ask?("value of #{key} in #{to_file}#{opts[:hint] ? " (#{opts[:hint]})" : ""}", '') if value == :ask
          inserted_value = "\"#{value}\"" if value
          if file_has_content?(to_file, "defaults: &defaults\n")
            insert_line_into_file(to_file, "  #{key}: #{inserted_value}", :after => "defaults: &defaults")
          else
            insert_line_into_file(to_file, "  #{key}: #{inserted_value}", :after => "development:")
            insert_line_into_file(to_file, "  #{key}: #{inserted_value}", :after => "test:")
          end
          return value
        end
      end
    end
  end
end