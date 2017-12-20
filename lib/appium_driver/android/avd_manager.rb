module AppiumDriver
  module Android
    module AVDManager
      def run_emulator
        cmd = "$ANDROID_HOME/tools/emulator -avd #{@avd_name} -port #{@avd_port}"
        puts cmd
        pid = spawn(cmd, out: '/dev/null')
        Process.detach(pid)
        sleep(30)
      end

      def kill_emulator
        system("adb -s emulator-#{@avd_port} emu kill")
      end

      def create_avd
        puts "Create emulator with name: #{@avd_name} and sdk: #{@sdk_version}"

        cmd = '$ANDROID_HOME/tools/bin/avdmanager create avd'
        cmd << " -n #{@avd_name}"
        cmd << " -d #{@avd_device}"
        cmd << " -k \"system-images;android-#{@sdk_version};google_apis;x86\""

        system(cmd)
      end

      def delete_avd
        puts "Delete emulator with name: #{@avd_name}"

        system("$ANDROID_HOME/tools/bin/avdmanager delete avd -n #{@avd_name}")
      end
    end
  end
end
