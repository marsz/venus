module Venus
  module Generators
    class SimpleFormGenerator < Base
      desc "Setup simpl_for related gems"

      def name
        "simple_form"
      end

      def asks
        @gems = ["simple_form"]
        @simple_form_config = ask?('generate simple_form config?', true)
        if @simple_form_config
          @generate_options = ask?('options for generate simple_form config, ex: "--bootstrap --foundation"', "")
        end
        @nested_form = ask?('install & setup "nested_form"?', true)
        if @nested_form
          @js_callback_target = ask?('nested_form callbacks js required in ?', 'application.js')
          @gems << "nested_form"
        end
      end

      def simple_form
        add_gem('simple_form')
        add_gem('nested_form') if @nested_form
        bundle_install
        ask_bundle_update
      end

      def nested_form
        if @nested_form
          if @js_callback_target.present?
            to_file = "app/assets/javascripts/#{@js_callback_target}"
            line = "//= require jquery_nested_form"
            insert_line_into_file(to_file, line, :after => "//= require jquery_ujs")
            line = "//= require jquery_nested_form_callbacks"
            insert_line_into_file(to_file, line, :after => "//= require jquery_nested_form")
            template("jquery_nested_form_callbacks.js", "app/assets/javascripts/jquery_nested_form_callbacks.js")
          else
            puts "see https://github.com/ryanb/nested_form for configuration"
          end
        end
      end

      def simple_form_generate_theme
        if @simple_form_config
          generate "simple_form:install #{@generate_options}"
        end
      end

    end
  end
end
