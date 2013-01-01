module Venus
  module Generators
    class PaginateGenerator < Base
      desc "Paginate"

      def name
        "Paginate"
      end

      def asks
        @kaminari_views = ask("generate kaminari views? [y/N]").downcase
        if has_gem?('haml') && @kaminari_views == 'y'
          @kaminari_haml = ask("Haml kaminari views? [Y/n]").downcase
        end
      end

      def gems
        add_gem('kaminari')
      end

      def run_bunle
        run 'bundle install'
      end

      def kaminari_views
        if @kaminari_views == 'y'
          haml = @kaminari_haml != 'n' ? ' -e haml' : ''
          generate 'kaminari:views default' + haml
        end
      end

    end
  end
end