module Venus
  module Generators
    class AwsGenerator < Base
      desc "Setup gem for 'aws-sdk'"

      def name
        "AWS"
      end

      def asks
        ::Venus::Aws.new.generate!
      end

    end
  end
end
