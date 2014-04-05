module Venus
  class Select2 < ::Venus::Base

    def generate
      asks
      add_gem('select2-rails')
      bundle_install
      ask_bundle_update
      assets
      code
      more
    end

    private

    def asks
      @target_js = ask?('target content append for js file?', 'application.js')
      @target_css = ask?('target content append for css file?', 'application.css')
      say "langiages: ar, ca, cs, da, de, el, es, et, eu, fi, fr, gl, he, hr, hu, id, is, it, ja, ko, lt, lv, mk, ms, nl, no, pl, pt-BR, pt-PT, ro, ru, sk, sv, tr, uk, vi, zh-CN, zh-TW"
      @lang = ask?('i18n lang', '')
      @bootstrap = ask?('bootstrap theme', false)
    end

    def assets
      css_assets_require(@target_css, "select2")
      css_assets_require(@target_css, "select2-bootstrap", :after => "require select2") if @bootstrap
      js_assets_require(@target_js, "select2")
      js_assets_require(@target_js, "select2_locale_#{@lang}", :after => "require select2") if @lang.present?
    end

    def code
      insert_js_template(@target_js, "select2.js")
    end

    def more
      say "more select2 options:"
      say "  http://ivaynberg.github.io/select2/#documentation"
      say "select2-rails:"
      say "  https://github.com/argerim/select2-rails"
    end
  end
end