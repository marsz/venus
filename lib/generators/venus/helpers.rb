module Venus
  module Generators
    module Helpers

      private

      def ask?(message, default_ans = true)
        postfix = " [" + (!!default_ans == default_ans ? (default_ans ? 'Y/n' : 'y/N') : default_ans.to_s) + "]"
        ans = ask("#{message}#{postfix}")
        return (ans.present? ? (['n','N'].include?(ans) ? false : ans) : default_ans)
      end

      def settingslogic_dependent
        say 'checking dependent gems "settinglogic"...'
        generate 'venus:settingslogic' unless has_gem?('settingslogic')
        @settinglogic_class = ask?("Your settinglogic class name?", 'Setting')
        @settinglogic_yml = ask?("Your settinglogic yaml file in config/ ?", 'setting.yml')
      end

      def key_in_settingslogic?(key)
        file_has_content?("config/#{@settinglogic_yml}", "  #{key}:")
      end

      def read_destanation_file(filepath)
        File.open(File.join(destination_root, filepath)).read
      end

      def file_has_content?(to_file, line)
        read_destanation_file(to_file).index(line)
      end

      def gem_version(gemname)
        if has_gem?(gemname)
          read_destanation_file('Gemfile.lock').scan(/ #{gemname} .+?([0-9\.a-z]+)/)[0][0] rescue nil
        end
      end

      def has_gem?(gemname)
        file_has_content?('Gemfile.lock', / #{gemname} \(/m)
      end

      def rails3?
        gem_version('rails').to_i < 4
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

      def gem_to_s(gemname, options = {})
        if options.is_a?(Hash)
          options = (options.size > 0 ? options.to_s[1..-2].gsub("=>", " => ") : "")
        elsif options.is_a?(String)
          options = "'#{options}'"
        end
        options = ", #{options}" if options.size > 0
        return "gem '#{gemname}'#{options}"
      end

      def add_gem(gemname, options = {})
        append_file("Gemfile", "\n#{gem_to_s(gemname, options)}") unless has_gem?(gemname)
      end

      def remove_gem(gemname)
        gsub_file("Gemfile", /\n.*?gem.+?#{gemname}.+?\n/, "\n")
      end

      def append_gem_into_group(groups, gemname, options = {})
        return if has_gem?(gemname)
        gemstr = "  "+gem_to_s(gemname, options)
        groups = [groups] unless groups.is_a?(Array)
        group_str = "group :#{groups.map(&:to_sym).join(", :")} do"
        if file_has_content?('Gemfile', group_str)
          insert_line_into_file("Gemfile", gemstr, :after => group_str)
        else
          append_file("Gemfile", "\n#{group_str}\nend\n")
          append_gem_into_group(groups, gemname, options)
        end
      end

      def insert_template(to_file, template_file, options = {})
        insert_content = load_template(template_file)
        if options[:force] == true || !file_has_content?(to_file, insert_content)
          options.delete(:force)
          inject_into_file(to_file,insert_content,options)
        end
      end

      def remove_line_from_file(to_file, line_pattern)
        line_pattern = /[\n]*.*?#{line_pattern}.*?[\n]*/ if line_pattern.is_a?(String)
        gsub_file(to_file, line_pattern, "\n")
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

      def bundle_update(gems)
        gems ||= []
        gems = [gems] unless gems.is_a?(Array)
        Bundler.with_clean_env do
          run "bundle update #{gems.join(" ")}" if gems.size > 0
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
        unless file_has_content?(to_file, "\n  #{key}:")
          value = '' if opts[:hide_in_example] && to_file.index('.example')
          value = ask?("value of #{key} in #{to_file}#{opts[:hint] ? " (#{opts[:hint]})" : ""}", '') if value == :ask
          inserted_value = (value.index("\n") ? value : "\"#{value}\"") if value
          if file_has_content?(to_file, "defaults: &defaults\n")
            insert_line_into_file(to_file, "  #{key}: #{inserted_value}", :after => "defaults: &defaults")
          else
            insert_line_into_file(to_file, "  #{key}: #{inserted_value}", :after => "development:")
            insert_line_into_file(to_file, "  #{key}: #{inserted_value}", :after => "test:")
          end
          return value
        end
      end

      def insert_settingslogics(key, value, opts = {})
        ["config/#{@settinglogic_yml}", "config/#{@settinglogic_yml}.example"].each_with_index do |to_file, i|
          is_example = (i == 0 ? false : true)
          value = '' if opts[:secret] && is_example
          inserted_value = (value.index("\n") ? value : "\"#{value}\"")
          line = "  #{key}: #{inserted_value}"
          if file_has_content?(to_file, "defaults: &defaults")
            insert_line_into_file(to_file, line, :after => "defaults: &defaults")
          else
            insert_line_into_file(to_file, line, :after => "development:")
            insert_line_into_file(to_file, line, :after => "test:")
          end
          gsub_file(to_file, "#{line}\n\n", "#{line}\n")
        end
      end
    end
  end
end