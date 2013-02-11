module Venus
  module Generators
    class BootstrapGenerator < Base
      desc "Setup for bootstrap theme"

      def name
        "bootstrap"
      end

      def asks
        @target_js = ask?('target content append for js file?', 'application.js')
        @target_css = ask?('target content append for css file?', 'application.css')
        @example_layout = ask?("Export example layout", 'bootstrap')
        @unicorn = ask?("Use theme unicorn admin", true)
      end

      def gemfile
        add_gem('anjlab-bootstrap-rails', ">= 2.3', :require => 'bootstrap-rails")
        bundle_install
      end

      def assets
        css_assets_require(@target_css, "twitter/bootstrap")
        css_assets_require(@target_css, "twitter/bootstrap-responsive", :after => "twitter/bootstrap")
        js_assets_require(@target_js, "twitter/bootstrap")
      end

      def unicorn
        if @unicorn
          template("unicorn.js", "app/assets/javascripts/unicorn.js")
          template("unicorn.main.css", "app/assets/stylesheets/unicorn.main.css")
          template("unicorn.grey.css", "app/assets/stylesheets/unicorn.grey.css")
          css_assets_require(@target_css, "unicorn.main", :after => "twitter/bootstrap-responsive")
          css_assets_require(@target_css, "unicorn.grey", :after => "unicorn.main")
          js_assets_require(@target_js, "unicorn", :after => "twitter/bootstrap")
          
        end
      end

      def copy_example_layout
        to_file = "app/views/layouts/#{@example_layout}.html.erb"
        copy_file("img/glyphicons-halflings-white.png", "app/assets/images/img/glyphicons-halflings-white.png")
        copy_file("img/glyphicons-halflings.png", "app/assets/images/img/glyphicons-halflings.png")
        if @unicorn
          copy_file("unicorn.layout", to_file)
          copy_file("img/breadcrumb.png", "app/assets/images/img/breadcrumb.png")
          copy_file("img/menu-active.png", "app/assets/images/img/menu-active.png")
          puts "see more uncorn admin example: http://wrapbootstrap.com/preview/WB0F35928"
        else
          copy_file("bootstrap.layout", to_file)
        end
        replace_in_file(to_file, "@target_css", @target_css)
        replace_in_file(to_file, "@target_js", @target_js)
        puts "see more bootdtrap usage: http://twitter.github.com/bootstrap/"
      end

    end
  end
end
