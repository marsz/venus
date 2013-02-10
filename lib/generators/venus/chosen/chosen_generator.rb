module Venus
  module Generators
    class ChosenGenerator < Base
      desc "Setup for jQuery chosen"

      def name
        "chosen"
      end

      def asks
        @target_js = ask?('target content append for js file?', 'application.js')
        @target_css = ask?('target content append for css file?', 'application.css')
      end

      def gem
        add_gem('chosen-rails', '~> 0.9.11.2')
        bundle_install
      end

      def assets
        css_assets_require(@target_css, "chosen")
        insert_js_template(@target_js, "chosen.js")
        js_assets_require(@target_js, "chosen-jquery")
      end

      def more
        puts "see more: https://github.com/tsechingho/chosen-rails"
      end

    end
  end
end
