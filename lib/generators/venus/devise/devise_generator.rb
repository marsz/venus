module Venus
  module Generators
    class DeviseGenerator < Base
      desc "Setup devise"

      def name
        "Devise"
      end

      def go
        Venus::Devise.new.generate!
      end

    end
  end
end