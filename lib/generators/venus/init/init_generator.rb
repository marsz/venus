module Venus
  module Generators
    class InitGenerator < Base
      desc "Setup essential gems"

      def name
        "initalize"
      end

      def asks
        @gems = {}
        @paginate = ask?('install paginate gem "kaminari"?', true) unless has_gem?('kaminari')
        generate 'venus:paginate' if @paginate

        @whenever = ask?('install scheduling gem "whenever"?', true) unless has_gem?('whenever')
        generate 'venus:cron' if @whenever

        @simple_form = ask?('install gem "simple_form"?', true) unless has_gem?('simple_form')
        if @simple_form
          generate "venus:simple_form"
        end

        @remove_gems = []
        ["coffee-rails", "sass-rails"].each do |gem_name|
          @remove_gems << gem_name unless ask?("use gem '#{gem_name}'", true)
        end

        @assets_gems = {}
        ["execjs", "therubyracer", "turbo-sprockets-rails3"].each do |gem_name|
          @assets_gems[gem_name] = ask?("gem '#{gem_name}' for assets", true)
        end

        @remove_require_tree = ask?("remove 'require_tree .' in application.css/js", true)
      end

      def remove_usless_file
        remove_file 'public/index.html'
        remove_file 'app/assets/images/rails.png'
      end
      
      def enable_email_delivery_error
        file = 'config/environments/development.rb'
        find = 'raise_delivery_errors = false'
        replace = 'raise_delivery_errors = true'
        replace_in_file(file, find, replace) if file_has_content?(file, find)
      end

      def remove_gems
        if @remove_gems.size > 0
          @remove_gems.each do |gem_name|
            gsub_file("Gemfile", /\n.*?gem.+?#{gem_name}.+?\n/, "\n")
          end
          bundle_install
        end
      end

      def assets_gems
        if @assets_gems.select{|gem_name,y|y}.size > 0
          @assets_gems.each do |gem_name,y|
            opts = (gem_name == "therubyracer") ? { :platforms => :ruby } : {}
            append_gem_into_group(:assets, gem_name, opts) if y
          end
        end
      end

      def gems
        @is_append = !file_has_content?('Gemfile','group :development do')
        if @is_append
          concat_template('Gemfile', 'gem_developments.erb')
        else
          insert_template('Gemfile', 'gem_developments.erb', :after => 'group :development do')
        end
        @gems.each do |gemname, ans|
          add_gem(gemname.to_s) if ans
        end
        bundle_install
      end

      def gitignore
        add_gitignore ".DS_Store"
        add_gitignore "/public/assets"
      end

      def remove_require_tree
        if @remove_require_tree
          remove_line_from_file("app/assets/javascripts/application.js", "require_tree .")
          remove_line_from_file("app/assets/stylesheets/application.css", "require_tree .")
        end
      end

    end
  end
end
