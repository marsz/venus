module Venus
  module Generators
    class ModelVersioningGenerator < Base
      desc "Setup paper_trail for model versioning"

      def name
        "paper_trail"
      end

      def asks
      end

      def gemfile
        add_gem('paper_trail')
        add_gem('differ')
        bundle_install
        ask_bundle_update
        generate 'paper_trail:install --with-changes'
        bundle_exec 'rake db:migrate' if ask?("run rake db:migrate", true)
      end

      def template_files
        template("paper_trail.rb.erb", "config/initializers/paper_trail.rb")
      end

      def more_info
        puts "  see more about gem: https://github.com/airblade/paper_trail"
        puts "  see more about differ usage: https://github.com/pvande/differ"
      end

    end
  end
end
