require_relative 'server_manager'

module AppiumDriver
  include ServerManager

  class Driver
    attr_reader :appium_args

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

      @appium_args = appium_args

      @vd_ctl.start_vd
      @appium_server = AppiumServer.new(appium_args)
      @appium_args = @appium_server.appium_args
    end

    def start
      @vd_ctl.start_vd(10)
    end

    def stop
      @vd_ctl.shutdown_vd
    end

    def exit
      stop
      @vd_ctl.delete_vd
      @appium_server.kill_appium_server
      super
    end
  end

  def kill_all_booted_simulators
    IOS::SimCtl.kill_all_booted_simulators
  end

  def kill_all_booted_emulators
    Android::AVDManager.kill_all_booted_emulators
  end

  def kill_all_appium_servers
    AppiumServer.kill_all_appium_servers
  end

  def kill_all
    kill_all_booted_simulators
    kill_all_booted_emulators
    kill_all_appium_servers
  end
end
