module Venus
  module Generators
    class BootstrapGenerator < Base
      desc "Setup for bootstrap theme"

      def name
        "bootstrap"
      end

      def go
        if !has_gem?("simple_form") && ask?("install simple_form")
          say 'checking dependent gems "simple_form"...'
          generate 'venus:simple_form' unless has_gem?('simple_form')
        end
        # @version = ask_with_opts("Bootstrap version?", {1 => 2.3, 2 => 3}, 1)
        @version = 2.3
        @target_js = ask?('target content append for js file?', 'application.js')
        @target_css = ask?('target content append for css file?', 'application.css')
        if @version < 3 
          twbs2
        else
          twbs3 # TODO
        end
      end

      private

      def twbs2
        @unicorn = ask?("Use theme unicorn admin", true) 
        add_gem('sass-rails', '>= 3.2')
        add_gem('bootstrap-sass', '~> 2.3')
        bundle_install
        ask_bundle_update
        # attach asset file
        css_assets_require(@target_css, "bootstrap")
        css_assets_require(@target_css, "bootstrap-responsive", :after => "bootstrap")
        js_assets_require(@target_js, "bootstrap")
        copy_file("img/glyphicons-halflings-white.png", "app/assets/images/img/glyphicons-halflings-white.png")
        copy_file("img/glyphicons-halflings.png", "app/assets/images/img/glyphicons-halflings.png")
        # layout
        to_file = "app/views/layouts/bootstrap_base.html.erb"
        target_css = @target_css.gsub(".css", "").gsub(".scss", "").gsub(".sass", "")
        target_js = @target_js.gsub(".js", "").gsub(".coffee", "")
        copy_file("bootstrap.layout", to_file)
        replace_in_file(to_file, "@target_css", target_css)
        replace_in_file(to_file, "@target_js", target_js)
        # unicorn
        if @unicorn
          # simple_form
          to_file = "config/initializers/simple_form.rb"
          insert_template(to_file, "simple_form_config.erb", :before => "\nend\n") if has_file?(to_file)
          # assets
          template("unicorn.js", "app/assets/javascripts/unicorn.js")
          template("unicorn.main.css.scss", "app/assets/stylesheets/unicorn.main.css.scss")
          template("unicorn.grey.css", "app/assets/stylesheets/unicorn.grey.css")
          css_assets_require(@target_css, "unicorn.main", :after => "bootstrap-responsive")
          css_assets_require(@target_css, "unicorn.grey", :after => "unicorn.main")
          js_assets_require(@target_js, "unicorn", :after => "bootstrap")
          copy_file("img/breadcrumb.png", "app/assets/images/img/breadcrumb.png")
          copy_file("img/menu-active.png", "app/assets/images/img/menu-active.png")
          copy_file("img/line.png", "app/assets/images/img/line.png")
          # layout
          unicorn_file = "app/views/layouts/bootstrap_unicorn.html.erb"
          copy_file("unicorn.layout", unicorn_file)
          replace_in_file(unicorn_file, "@target_css", target_css)
          replace_in_file(unicorn_file, "@target_js", target_js)
          say "see more uncorn admin example: http://wbpreview.com/previews/WB0F35928/"
        end
        generate "simple_form:install --bootstrap" if !has_file?("config/initializers/simple_form_bootstrap.rb") && ask?("generate simple_form config for bootstrap", true)
        say "see more bootdtrap usage: http://twitter.github.com/bootstrap/"
      end

      def twbs3
        add_gem('sass-rails', '>= 3.2')
        add_gem('bootstrap-sass')
        bundle_install
        ask_bundle_update
        css_assets_require(@target_css, "bootstrap")
        js_assets_require(@target_js, "bootstrap")
        # TODO layout
      end

    end
  end
end
