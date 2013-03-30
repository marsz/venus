module Venus
  module Generators
    class VersioningGenerator < Base
      desc "Setup paper_trail for model versioning"

      def name
        "paper_trail"
      end

      def asks
        @differ = ask?("install differ?", true)
      end

      def gemfile
        add_gem('paper_trail', '~> 2.7.1')
        add_gem('differ', '~> 0.1.2') if @differ
        bundle_install
        generate 'paper_trail:install --with-changes'
        bundle_exec 'rake db:migrate' if ask?("run db migrate", true)
      end

      def template_files
        template("paper_trail.rb.erb", "config/initializers/paper_trail.rb")
      end

      def more_info
        puts "see more: https://github.com/airblade/paper_trail"
      end

    end
  end
end
