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
        bundle_install
      end

      def kaminari_views
        if @kaminari_views
          haml = lambda {|x| (x.nil? or x == false) ? '' : ' -e haml'}.call(@kaminari_haml)
          generate 'kaminari:views default' + haml
        end
      end

    end
  end
end
