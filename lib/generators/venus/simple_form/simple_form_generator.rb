module Venus
  module Generators
    class SimpleFormGenerator < Base
      desc "Setup simpl_for related gems"

      def name
        "simple_form"
      end

      def asks
        @gems = {}
        @simple_form_config = ask?('generate simple_form config?', true)
        @nested_form = ask?('install gem "nested_form"?', true) unless has_gem?('nested_form')
        if @nested_form
          @js_callback_target = ask?('JS event callback template target?', 'application.js')
        end
      end

      def simple_form
        add_gem('simple_form', '~> 2.0.4')
        add_gem('nested_form') if @nested_form
        bundle_install
      end

      def nested_form
        if @nested_form
          if @js_callback_target.present?
            to_file = "app/assets/javascripts/#{@js_callback_target}"
            line = "//= require jquery_nested_form"
            insert_line_into_file(to_file, line, :after => "//= require jquery_ujs")
            line = "//= require_self"
            insert_line_into_file(to_file, line, :after => "//= require jquery_nested_form")
            concat_template(to_file, "nested_form_event.js")
          else
            puts "see https://github.com/ryanb/nested_form for configuration"
          end
        end
      end

      def simple_form_generate_theme
        if @simple_form_config
          generate 'simple_form:install'
          # TODO best template views
        end
      end

    end
  end
end
