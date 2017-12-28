module Android
  module SDKManager
    def converting_to_sdk_version(platform_version)
      sdk_list = {
        '4.1' => '16',
        '4.4' => '19',
        '5.0' => '21',
        '5.1' => '22',
        '6.0' => '23',
        '7.0' => '24',
        '7.1' => '25',
        '8.0' => '26'
      }
      sdk_list.default = '25'
      sdk_list[platform_version.to_s]
    end

    def install_sdk(version)
      puts "Install SDK #{version}"

      system(
        '$ANDROID_HOME/tools/bin/sdkmanager '\
        "\"system-images;android-#{version};google_apis;x86\""
      )
    end

    def uninstall_sdk(version)
      puts "Uninstall SDK #{version}"

      system(
        '$ANDROID_HOME/tools/bin/sdkmanager --uninstall '\
        "\"system-images;android-#{version};google_apis;x86\""
      )
    end

    def update_sdk
      puts 'Update SDK'

      system('$ANDROID_HOME/tools/bin/sdkmanager --update')
    end
  end
end
