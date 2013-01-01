module Venus
  module Generators
    class InitGenerator < Base
      desc "Setup essential gems"

      def name
        "initalize"
      end

      def asks
        @gems = {}
        [:simple_form, :nested_form, :haml, :whenever].each do |gemname|
          @gems[gemname] = ask?("install gem '#{gemname}'?", true)
        end
        @gem_development = ask?("install group gems for development?", true)
        @paginate = ask?('install paginate gem "kaminari"?', true) unless has_gem?('kaminari')
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
        if @gem_development
          @is_append = !file_has_content?('Gemfile','group :development do')
          if @is_append
            concat_template('Gemfile', 'gem_developments.erb')
          else
            insert_template('Gemfile', 'gem_developments.erb', :after => 'group :development do')
          end
        end
        @gems.each do |gemname, ans|
          add_gem(gemname.to_s) if ans
        end
      end

      def run_bunle
        run 'bundle install'
      end

      def paginate
        if @paginate
          generate 'venus:paginate'
        end
      end

    end
  end
end