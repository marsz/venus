module Venus
  module Generators
    class JqueryuiGenerator < Base
      desc "Setup for jQuery UI"

      def name
        "jqueryui"
      end

      def asks
        @target_js = ask?('target content append for js file?', 'application.js')
        @target_css = ask?('target content append for css file?', 'application.css')
        @datepicker = ask?('setup for datepicker?', true)
        if @datepicker
          say "datepicker lang list: https://github.com/joliss/jquery-ui-rails/blob/master/app/assets/javascripts"
          @datepicker_lang = ask?('datepicker language?', 'en')
          @datetimepicler = ask?('setup timepicker ?', true)
        end
      end

      def gem
        need_bundle_update = has_gem?("jquery-ui-rails")
        add_gem('jquery-ui-rails')
        bundle_install
        bundle_update('jquery-ui-rails') if need_bundle_update
      end

      def datepicker
        if @datepicker
          css_assets_require(@target_css, "jquery.ui.datepicker")
          insert_js_template(@target_js, "datepicker.js")
          js_assets_require(@target_js, "jquery.ui.datepicker")
          js_assets_require(@target_js, "jquery.ui.datepicker-#{@datepicker_lang}") if @datepicker_lang.present? && @datepicker_lang != 'en'
        end
      end

      def timepicker
        if @datetimepicler
          copy_file("jquery.timepicker.js", "app/assets/javascripts/jquery.timepicker.js")
          copy_file("jquery.timepicker.css", "app/assets/stylesheets/jquery.timepicker.css")
          css_assets_require(@target_css, "jquery.ui.slider")
          css_assets_require(@target_css, "jquery.timepicker")
          js_assets_require(@target_js, "jquery.ui.slider")
          js_assets_require(@target_js, "jquery.timepicker")
          insert_js_template(@target_js, "timepicker.js")
        end
      end

      def more
        say "  see more jqueryui-rails: https://github.com/joliss/jquery-ui-rails"
        say "  see more timepicker: https://github.com/trentrichardson/jQuery-Timepicker-Addon"
      end

    end
  end
end
