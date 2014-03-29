module Venus
  module Generators
    class InitGenerator < Base
      desc "Setup essential gems"

      def name
        "initalize"
      end

      def asks
        @remove_gems = []
        ["coffee-rails", "sass-rails", "jbuilder"].each do |gem_name|
          @remove_gems << gem_name unless ask?("use gem '#{gem_name}'", true)
        end

        @assets_gems = {}
        gems = rails3? ? ["execjs", "therubyracer", "turbo-sprockets-rails3"] : ["therubyracer"]
        gems.each do |gem_name|
          @assets_gems[gem_name] = ask?("gem '#{gem_name}' for assets", true)
        end

        @remove_require_tree = ask?("remove 'require_tree .' in application.css/js", true)
      end

      def remove_usless_file
        remove_file 'public/index.html'
        remove_file 'app/assets/images/rails.png'
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
        @assets_gems.select{|gem_name,y|y}.each do |gem_name,y|
          add_gem(gem_name)
        end
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
