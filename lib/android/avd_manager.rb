require_relative '../appium_driver/server_manager'
require_relative 'sdk_manager'

module Android
  class AVDManager
    attr_reader :platform_name
    attr_reader :platform_version
    attr_reader :avd
    attr_reader :avd_args
    attr_reader :sdk_version
    attr_reader :device_id

    include SDKManager
    include AppiumDriver::ServerManager

    DEFAULT_AVD_PORTS = 5556..5620

    def initialize(args = {})
      @platform_name = 'Android'
      @platform_version = args.fetch :platform_version, '7.1'
      @sdk_version = converting_to_sdk_version(@platform_version)
      @device_id = args.fetch :device_name, 9 # Nexus 5X
      @avd_args = { port: search_free_port(DEFAULT_AVD_PORTS) }
      @avd = "avd_v#{@sdk_version}_#{@avd_args[:port]}"

      create
    end

    def create
      if vd_exists?
        puts "Emulator with name: #{@avd} already exists"
        delete
      end

      puts "Create emulator with name: #{@avd} and sdk: #{@sdk_version}"

      cmd = '$ANDROID_HOME/tools/bin/avdmanager create avd'
      cmd << " -n #{@avd}"
      cmd << " -d #{@device_id}"
      cmd << " -k \"system-images;android-#{@sdk_version};google_apis;x86\""

      unless system(cmd)
        update_sdk
        install_sdk(@sdk_version)
        system(cmd)
      end
    end

    def start(sleep_duration: 30, erase: false)
      puts "Running AVD #{@avd}"

      cmd = "$ANDROID_HOME/tools/emulator -avd #{@avd} -port #{@avd_args[:port]}"
      cmd << ' -wipe-data' if erase

      pid = spawn(cmd, out: '/dev/null')
      Process.detach(pid)

      sleep(sleep_duration)
    end

    def erase
      shutdown
      start(erase: true)
    end

    def vd_exists?
      !`$ANDROID_HOME/tools/bin/avdmanager list avd | grep 'Name: #{@avd}'`.empty?
    end

    def device_name
      `$ANDROID_HOME/tools/bin/avdmanager list device | grep 'id: #{@device_id} or'`.split('"')[1]
    end

    def shutdown
      self.class.shutdown(@avd_args[:port])
    end

    def delete
      self.class.delete(@avd)
    end

    class << self
      def shutdown(port)
        puts "Shutdown AVD: emulator-#{port}"

        system("adb -s emulator-#{port} emu kill")

        30.times do
          port_open?(port) ? sleep(1) : break
        end
      end

      def delete(avd)
        puts "Delete AVD: #{avd}"

        system("$ANDROID_HOME/tools/bin/avdmanager delete avd -n #{avd}")
      end

      def kill_all_booted_emulators
        emulator_list = `adb devices | grep emulator | cut -f1`.split("\n")
        emulator_list.each do |name|
          `adb -s #{name} emu kill`
        end
      end
    end
  end
end
