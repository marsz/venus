module Venus
  class Pg < ::Venus::Base

    def generate
      asks
      gems
      gitignore
      config_yml
      create_db
    end

    private

    def asks
      @gis = ask?("gis adapter", true)
      @user = ask?("database login user?", 'root')
      @pass = ask?("database login password?", '')
      @db = ask?("database name? (will append rails env as postfix)", app_name)
      @recreate = ask?("drop db before create?", true)
    end

    def gems
      add_gem('pg')
      add_gem('activerecord-postgres-hstore') if rails3?
      add_gem('activerecord-postgis-adapter') if @gis
      bundle_install
      ask_bundle_update
    end

    def gitignore
      add_gitignore "config/database.yml"
    end

    def config_yml
      @adapter = @gis ? 'postgis' : 'postgresql'
      template 'pg.yml.erb', 'config/database.yml'
      @pass = ''
      template 'pg.yml.erb', 'config/database.yml.example', :force => true
      `git rm config/database.yml --cache`
    end

    def create_db
      bundle_exec('rake db:drop') if @recreate
      bundle_exec('rake db:create')
    end
  end
end