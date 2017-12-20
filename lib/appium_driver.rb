require 'appium_lib'
require 'pry-byebug'
require 'socket'
require 'timeout'
require 'yaml'

gem_directory = Gem::Specification.find_by_name("appium_driver").gem_dir
Dir["#{gem_directory}/lib/appium_driver/**/*.rb"].each { |file| require file }

module AppiumDriver
  class Driver
    attr_accessor :appium_port
    attr_accessor :sdk_version
    attr_accessor :avd_port
    attr_accessor :avd_name
    attr_accessor :avd_device
    attr_accessor :threads_count

    include AppiumServer
    include Android::AVDManager
    include ServerManager

    def initialize(opts = {})
      raise('$ANDROID_HOME not available') unless sdk_home_available?
      raise('$APPIUM_HOME not available') unless appium_home_available?

      @appium_port = opts.fetch :appium_port, search_free_port(4723..4787, '0.0.0.0')
      @sdk_version = opts.fetch :sdk_version, 25 # Android 7.1
      @avd_port = opts.fetch :avd_port, search_free_port(5556..5620, '127.0.0.1')
      @avd_name = opts.fetch :avd_name, "avd_v#{@sdk_version}_#{@avd_port}"
      @avd_device = opts.fetch :sdk_device, 9 # Nexus 5X
      @threads_count = opts.fetch :threads_count, 1
      @reboot_avd = opts.fetch :reboot_avd, false

      start
    end

    def start
      create_avd

      if @reboot_avd
        start_appium_server_with_avd
      else
        run_emulator
        start_appium_server
      end
    end

    def stop
      kill_emulator
      delete_avd
      kill_appium_server
      exit
    end

    def appium_home_available?
      !`echo $APPIUM_HOME`.empty?
    end

    def sdk_home_available?
      !`echo $ANDROID_HOME`.empty?
    end

    def kill_all
      kill_all_emulators
      kill_all_appium_servers
    end

    def kill_all_appium_servers
      (4723..4787).each do |port|
        port_open?('0.0.0.0', port) && kill_process_at_port(port)
      end
    end

    def kill_all_emulators
      emulator_list = `adb devices | grep emulator | cut -f1`.split("\n")
      emulator_list.each do |name|
        `adb -s #{name} emu kill`
      end
    end
  end
end
