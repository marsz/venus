module Venus
  module Generators
    class InitGenerator < Base
      desc "Init Setup"

      def name
        "initalize"
      end

      def asks
        @gems = {}
        [:simple_form, :nested_form, :haml, :whenever].each do |gemname|
          @gems[gemname] = ask("install gem '#{gemname}'? [Y/n]").downcase
        end
        @gem_development = ask("install group gems for development? [Y/n]").downcase
        @paginate = ask('install paginate gem "kaminari"? [Y/n]')
      end

      def gems
        if @gem_development != 'n'
          @is_append = !file_has_content?('Gemfile','group :development do')
          if @is_append
            concat_template('Gemfile', 'gem_developments.erb')
          else
            insert_template('Gemfile', 'gem_developments.erb', :after => 'group :development do')
          end
        end
        @gems.each do |gemname, ans|
          add_gem(gemname.to_s) if ans != 'n' && !has_gem?(gemname)
        end
      end

      def run_bunle
        run 'bundle install'
      end

      def paginate
        if @paginate != 'n'
          generate 'venus:paginate'
        end
      end

    end
  end
end