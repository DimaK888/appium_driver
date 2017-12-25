module Android
  class SDKManager
    class << self
      def sdk_version(platform_version)
        SDK['sdk_version'][platform_version.to_f]
      end

      def install_sdk(version)
        puts "Install SDK #{version}"

        system(
          "$ANDROID_HOME/tools/bin/sdkmanager "\
          "\"system-images;android-#{version};google_apis;x86\""
        )
      end

      def uninstall_sdk(version)
        puts "Uninstall SDK #{version}"

        system(
          "$ANDROID_HOME/tools/bin/sdkmanager --uninstall "\
          "\"system-images;android-#{version};google_apis;x86\""
        )
      end

      def update_sdk
        puts 'Update SDK'

        system("$ANDROID_HOME/tools/bin/sdkmanager --update")
      end
    end
  end
end
