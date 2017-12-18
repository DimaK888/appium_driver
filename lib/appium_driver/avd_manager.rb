module AppiumDriver
  module AVDManager
    class << self
      attr_writer :name, :port, :sdk_version

      def initialize(emulator_options = {})
        unless sdk_home_available?
          raise('$ANDROID_HOME not available')
        end

        @name = emulator_options.fetch :name
        @port = emulator_options.fetch :port
        @sdk_version = emulator_options.fetch :sdk_version, 25
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
        #TODO
      end

      def delete_avd
        #TODO
      end
    end

    def sdk_home_available?
      !`echo $ANDROID_HOME`.empty?
    end

    def kill_all_emulators
      emulator_list = `adb devices | grep emulator | cut -f1`.split("\n")
      emulator_list.each do |name|
        `adb -s #{name} emu kill`
      end
    end
  end
end
