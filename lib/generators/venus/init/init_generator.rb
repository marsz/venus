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

        [:haml].each do |gemname|
          @gems[gemname] = ask?("install gem '#{gemname}'?", true)
        end

        @simple_form = ask?('install gem "simple_form"?', true) unless has_gem?('simple_form')
        if @simple_form
          generate "venus:simple_form"
        end
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

    end
  end
end
