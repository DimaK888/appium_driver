require_relative 'server_manager'

module AppiumDriver
  include ServerManager

  class Driver
    def initialize(appium_args = {})
      raise('$ANDROID_HOME not available') if `echo $ANDROID_HOME`.empty?
      raise('$APPIUM_HOME not available') if `echo $APPIUM_HOME`.empty?

      appium_args[:platform_name] ||= 'android'

      if appium_args[:platform_name].downcase == 'ios'
        @vd_ctl = IOS::SimCtl.new(appium_args)
        appium_args[:udid] = @vd_ctl.udid
      else
        @vd_ctl = Android::AVDManager.new(appium_args)
        appium_args[:avd] = @vd_ctl.avd
        appium_args[:avd_args] = @vd_ctl.avd_args
      end

      appium_args[:platform_name] = @vd_ctl.platform_name
      appium_args[:platform_version] = @vd_ctl.platform_version
      appium_args[:device_name] = @vd_ctl.device_name

      @vd_ctl.start_vd

      @appium_server = AppiumServer.new(appium_args)
    end

    def stop
      @vd_ctl.shutdown_vd
      @vd_ctl.delete_vd
      @appium_server.kill_appium_server
    end
  end

  def kill_all
    kill_all_emulators
    kill_all_appium_servers
  end

  def kill_all_appium_servers
    (4723..4787).each do |port|
      port_open?(port) && kill_process_at_port(port)
    end
  end

  def kill_all_emulators
    emulator_list = `adb devices | grep emulator | cut -f1`.split("\n")
    emulator_list.each do |name|
      `adb -s #{name} emu kill`
    end
  end
end
