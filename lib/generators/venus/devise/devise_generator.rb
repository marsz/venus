module Venus
  module Generators
    class DeviseGenerator < Base
      desc "Setup devise"

      def name
        "Devise"
      end

      def asks
        @views = ask?("Generate views?", false)
        # if @views == 'y' && has_gem?('haml')
        #   @haml = ask("Use haml? [Y/n]").downcase
        # end
      end

      def gemfile
        add_gem('devise', "~> 2.1.2")
        run 'bundle install'
      end

      def generates
        generate 'devise:install'
        generate 'devise User'
      end

      def views
        if @views
          generate 'devise:views -e erb'
          # if @haml != 'n'
          #   run 'gem install haml hpricot ruby_parser'
          #   run "for i in `find app/views/devise -d -name '*.erb'` ; do html2haml -e $i ${i%erb}haml ; rm $i ; done"
          # end
        end
      end

    end
  end
end