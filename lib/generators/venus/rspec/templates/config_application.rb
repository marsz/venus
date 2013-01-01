
    # disable some file generators
    config.generators.stylesheets = false
    config.generators.javascripts = false
    config.generators.helper = false
    config.generators.helper_specs = false

    # factory gilr
    config.generators do |g|
      g.test_framework :rspec, :fixture => true, :views => false, :fixture_replacement => :factory_girl
      g.fixture_replacement :factory_girl, :dir => "spec/factories" 
    end    
