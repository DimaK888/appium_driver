module Android
  module SDKManager
    def converting_to_sdk_version(platform_version)
      case platform_version.to_f
      when 4.1 then '16'
      when 4.4 then '19'
      when 5.0 then '21'
      when 5.1 then '22'
      when 6.0 then '23'
      when 7.0 then '24'
      when 7.1 then '25'
      when 8.0 then '26'
      else ''
      end
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
