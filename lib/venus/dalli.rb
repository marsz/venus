module Venus
  class Dalli < ::Venus::Base

    def generate
      asks
      add_gem('dalli')
      add_gem('connection_pool') if @connection_pool
      bundle_install
      ask_bundle_update
      configuration
      cache_store
      session_store
    end

    private

    def asks
      @cache_store = ask?('setup cache store?', true)
      @session_store = ask?('setup session store?', false)
      @connection_pool = ask?('use connection_pool (only dalli > 2.7)?', false)
    end

    def configuration
    end

    def cache_store
      if @cache_store
        settingslogic_dependent
        options = {
          :dalli => {
            :servers => ['127.0.0.1'],
            :options => {
              :namespace => app_name,
              :expires_in => 0,
              :threadsafe => true,
              :failover => true,
              :compress => false,
              :keepalive => true,
              :username => nil,
              :password => nil,
            }
          }
        }
        options[:dalli][:options][:pool_size] = 1 if @connection_pool
        settingslogic_insert(options)
        config_env_files.each do |to_file|
          change_config_value(to_file, "config.cache_store", "= :dalli_store, *(Setting.dalli.servers + [ Setting.dalli.options.symbolize_keys ])", :before => "\nend")
          uncomment_lines(to_file, "config.cache_store")
          replace_in_file(to_file, "\nconfig.cache_store", "\n  config.cache_store") rescue nil
        end
        comment_lines("config/application.rb", "config.cache_store")
      end
    end

    def session_store
      if @session_store
        template("dalli.rb.erb", "config/initializers/dalli.rb")
      end
    end

    def more
      say "see more about dalli :"
      say "  https://github.com/mperham/dalli#configuration"
    end

  end
end