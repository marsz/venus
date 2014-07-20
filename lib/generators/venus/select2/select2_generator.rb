module Venus
  module Generators
    class Select2Generator < Base

      def name
        "select2"
      end

      def go
        ::Venus::Select2.new.generate!
      end

    end
  end
end
