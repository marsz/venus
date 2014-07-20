module Venus
  class Omniauth < ::Venus::Base

    def generate!
      asks
      ask_providers
      devise_dependent_with_model(@devise_model)
      settingslogic_dependent
      gemfile
      configs
      models
      classes_files
      rpsec_files if has_gem?('rspec')
      migrate
    end

    private

    def asks
      @devise_model = Venus::Devise.new.ask_model
      @devise_scope = @devise_model.underscore
      @devise_table = @devise_model.tableize
    end

    def ask_providers
      @providers = {}
      @default_tokens = {
        :facebook => ["267188576687915", "84f72292e1f6b299f4a668f12ed1a7f2", { :perms => "email" } ],
        :github => ["3f9e288d55d83eee797d", "acc2d9185cdb236ffc227d4def846f3ade928710", { } ],
        :google_oauth2 => ["435467283040.apps.googleusercontent.com", "mbH4YxQuRRakaKDyyxGkwVTA", { } ]
        # :twitter => ["", "", {}]
      }
      @default_tokens.keys.each do |provider|
        if ask?("Use '#{provider}'?", true)
          token = ask?("#{provider.capitalize} App ID?", @default_tokens[provider][0])
          secret = ask?("#{provider.capitalize} App Secret?", @default_tokens[provider][1])
          @providers[provider] = { :app_id => token, :app_secret => secret, :scope => @default_tokens[provider][2] }
        end
      end
    end

    def gemfile
      add_gem('omniauth')
      @providers.each do |provider, |
        provider = "google-oauth2" if provider.to_s.index("google")
        add_gem("omniauth-#{provider}")
      end
      bundle_install
      ask_bundle_update
    end

    def configs
      settingslogic_insert :omniauth => @providers
      insert_template('config/routes.rb', 'omniauth/routes.erb', :after => "routes.draw do\n")
      template 'omniauth/initializers.erb', 'config/initializers/omniauth.rb'
    end

    def models
      generate "model identity provider:string uid:string #{@devise_scope}_id:integer auth_data:text"
      insert_template 'app/models/identity.rb', 'omniauth/identity.rb.erb', :after => "ActiveRecord::Base\n"
      insert_line_into_file "app/models/#{@devise_scope}.rb", "  has_many :identities", :after => "ActiveRecord::Base\n"
      sleep(1)
      migration_template "omniauth/migration.rb.erb", "db/migrate/add_index_to_identities"
    end

    def classes_files
      template 'omniauth/controller.rb.erb', "app/controllers/#{@devise_scope}_sessions_controller.rb"
      template 'omniauth/context.rb.erb', "app/contexts/#{@devise_scope}_oauth_context.rb"
    end

    def rpsec_files
      template 'omniauth/rspec_init.rb.erb', "spec/support/omniauth.rb"
      template 'omniauth/rspec_context.rb.erb', "spec/contexts/#{@devise_scope}_oauth_context_spec.rb"
      template 'omniauth/factorygirl_identity.rb.erb', "spec/factories/identities.rb"
    end

    def migrate
      bundle_exec('rake db:migrate') if ask?("Run 'rake db:migrate'?", true)
    end

  end
end