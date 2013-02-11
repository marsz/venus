module Venus
  module Generators
    class RedisGenerator < Base
      desc "Setup for redis"

      def name
        "venus-redis-related"
      end

      def asks
        say 'checking dependent gems "settinglogic"...'
        generate 'venus:settingslogic' unless has_gem?('settingslogic')

        @settinglogic_class = ask?("Your settinglogic class name?", 'Setting')
        @settinglogic_yml = ask?("Your settinglogic yaml file in config/ ?", 'setting.yml')
        @redis_object = ask?("Install gem 'redis-object'", true)
      end

      def gemfile
        add_gem('redis', '~> 3.0.2')
        add_gem('redis-objects', :require => 'redis/objects') if @redis_object
        bundle_install
      end

      def configs
        template 'redis.erb', 'config/initializers/redis.rb'
        to_file = "config/#{@settinglogic_yml}"
        [to_file, to_file+".example"].each do |file|
          insert_into_setting_yml(file, "redis", nil)
          insert_line_into_file(file, "    host: localhost\n    port: 6379\n    db: 0", :after => "  redis: \n")
        end
        puts "see more redis usage in: http://rdoc.info/github/redis/redis-rb/Redis"
      end

      def redis_objects
        puts "see more redis-objects usage in: https://github.com/nateware/redis-objects" if @redis_object
      end

    end
  end
end
