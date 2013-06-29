module Venus
  module Generators
    class RailsPanelGenerator < Base
      desc "Setup rails panel"

      def name
        "rails_panel"
      end

      def gemfile
        append_gem_into_group("development", "meta_request")
        bundle_install
        say "Install Chrome exts: https://chrome.google.com/webstore/detail/railspanel/gjpfobpafnhjhbajcjgccbbdofdckggg"
      end

    end
  end
end
