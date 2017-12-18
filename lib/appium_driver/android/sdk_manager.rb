module AppiumDriver
  module Android
    class SDKManager
      def install_sdk(version)
        system(
          "$ANDROID_HOME/tools/bin/sdkmanager "\
          "\"system-images;android-#{version};google_apis;x86\""
        )
      end

      def uninstall_sdk(version)
        system(
          "$ANDROID_HOME/tools/bin/sdkmanager --uninstall "\
          "\"system-images;android-#{version};google_apis;x86\""
        )
      end

      def update_sdk
        system("$ANDROID_HOME/tools/bin/sdkmanager --update")
      end
    end
  end
end
