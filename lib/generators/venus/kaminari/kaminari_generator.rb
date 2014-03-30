module Venus
  module Generators
    class KaminariGenerator < Base
      desc "Kaminari gem"

      def name
        "kaminari"
      end

      def asks
        @views = ask?("generate kaminari views?", true)
        if @views
          @slim = ask?("template engine with slim?", false)
          @theme = ask?("theme of kaminari views? [default / bootstrap / github / google]", 'default')
        end
        @i18n = ask?("download locals yml to config/locals/", true)
      end

      def gems
        add_gem('kaminari')
        add_gem('slim') if @slim && !has_gem?('slim')
        bundle_install
        ask_bundle_update
      end

      def config
        generate "kaminari:config"
      end

      def views
        if @views
          slim = @slim ? ' --template-engine=slim' : ''
          puts @theme
          generate "kaminari:views #{@theme} #{slim}"
        end
      end

      def locales
        if @i18n
          to_file = "#{destination_root}/config/locales/kaminari.yml"
          `wget https://raw.githubusercontent.com/amatsuda/kaminari/master/config/locales/kaminari.yml -O #{to_file} --no-check-certificate`
        end
      end

    end
  end
end
