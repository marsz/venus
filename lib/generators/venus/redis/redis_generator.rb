module Venus
  module Generators
    class RedisGenerator < Base
      desc "Setup for redis"

      def name
        "venus-redis-related"
      end

      def asks
        settingslogic_dependent
        @passenger = ask?("use passenger (add code for after fork if Yes)", false)
        @redis_object = ask?("install gem 'redis-object'", false)
      end

      def gemfile
        add_gem('redis')
        add_gem('redis-objects', :require => 'redis/objects') if @redis_object
        bundle_install
        ask_bundle_update
      end

      def configs
        template 'redis.erb', 'config/initializers/redis.rb'
        settingslogic_insert(:redis => { :url => "redis://127.0.0.1:6379/0" })
        say "see more redis usage in: http://rdoc.info/github/redis/redis-rb/Redis"
      end

      def redis_objects
        say "see more redis-objects usage in: https://github.com/nateware/redis-objects" if @redis_object
      end

    end
  end
end
