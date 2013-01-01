module Venus
  module Generators
    class PaginateGenerator < Base
      desc "Pagination gem - 'kaminari'"

      def name
        "Paginate"
      end

      def asks
        @kaminari_views = ask?("generate kaminari views?", false)
        if has_gem?('haml') && @kaminari_views
          @kaminari_haml = ask?("Haml kaminari views?", true)
        end
      end

      def gems
        add_gem('kaminari')
      end

      def run_bunle
        run 'bundle install'
      end

      def kaminari_views
        if @kaminari_views
          haml = @kaminari_haml != 'n' ? ' -e haml' : ''
          generate 'kaminari:views default' + haml
        end
      end

    end
  end
end