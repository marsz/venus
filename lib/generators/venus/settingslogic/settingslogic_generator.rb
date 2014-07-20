module Venus
  module Generators
    class SettingslogicGenerator < Base
      desc "Install gem settinglogic"

      def name
        "Settinglogic"
      end

      def go
        ::Venus::Settingslogic.new.generate!
      end



    end
  end
end