module Venus
  module Generators
    class CronGenerator < Base
      desc "Setup gem 'whenever' for scheduling"

      def name
        "Cron"
      end

      def asks
        @capistrano = ask?("integrate to capistrano?", true) if has_gem?('capistrano') && has_file?('config/deploy.rb')
      end

      def gemfile
        add_gem('whenever')
        bundle_install
        bundle_exec('wheneverize .')
      end

      def capistrano
        if @capistrano
          content = load_template('capistrano.erb')
          to_file = 'config/deploy.rb'
          unless file_has_content?(to_file, /[^#]*require[ ]*['"]whenever\/capistrano['"]/)
            prepend_file(to_file, content)
          end
        end
      end

    end
  end
end