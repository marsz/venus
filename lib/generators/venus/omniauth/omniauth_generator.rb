module Venus
  module Generators
    class OmniauthGenerator < Base
      desc "Setup gem 'omniauth' with multi providers"

      def name
        "Omniauth"
      end

      def go
        Venus::Omniauth.new.generate!
      end

    end
  end
end
