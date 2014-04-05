module Venus
  module Generators
    class Select2Generator < Base

      def name
        "select2"
      end

      def generate
        Venus::Select2.new.generate
      end

    end
  end
end
