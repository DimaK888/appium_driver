module Extensions
  module Android
    module AVDManager
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
end