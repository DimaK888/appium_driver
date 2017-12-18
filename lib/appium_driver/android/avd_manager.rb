module AppiumDriver
  module Android
    class AVDManager
      attr_writer :name, :port, :sdk_version

      def initialize(emulator_options = {})
        unless sdk_home_available?
          raise('$ANDROID_HOME not available')
        end

        @name = emulator_options.fetch :name
        @port = emulator_options.fetch :port
        @sdk_version = emulator_options.fetch :sdk_version, 25 # Android 7.1
        @device = emulator_options.fetch :sdk_version, 9 # Nexus 5X
      end

      def run_emulator
        cmd = "$ANDROID_HOME/tools/emulator -avd #{@name} -port #{@port}"
        puts cmd
        pid = spawn(cmd, :out => '/dev/null')
        Process.detach(pid)
        sleep(30)
      end

      def kill_emulator
        `adb -s #{@name} emu kill`
      end

      def create_avd
        puts "Create emulator with name: #{@name} and sdk: #{@sdk_version}"

        cmd = '$ANDROID_HOME/tools/bin/avdmanager create avd'
        cmd << " -n #{@name}"
        cmd << " -d #{@device}"
        cmd << " -k \"system-images;android-#{@sdk_version};google_apis;x86\""

        system(cmd)
      end

      def delete_avd
        puts "Delete emulator with name: #{@name}"

        system("$ANDROID_HOME/tools/bin/avdmanager delete avd -n #{@name}")
      end
    end
  end
end
