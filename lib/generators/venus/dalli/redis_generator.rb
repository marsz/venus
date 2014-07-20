module Venus
  module Generators
    class DalliGenerator < Base
      desc "Setup for dalli (memcahced server)"

      def name
        "dalli"
      end

      def go
        Venus::Dalli.new.generate!
      end

    end
  end
end
