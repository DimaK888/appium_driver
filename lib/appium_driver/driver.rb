require_relative 'server_manager'

module AppiumDriver
  include ServerManager

  class Driver
    attr_reader :appium_args

    def initialize(appium_args = {})
      raise('$ANDROID_HOME not available') if `echo $ANDROID_HOME`.empty?
      raise('$APPIUM_HOME not available') if `echo $APPIUM_HOME`.empty?

      appium_args = symbolize_keys(appium_args)

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

      @vd_ctl.start
      start_appium_server
    end

    def start_appium_server
      @appium_server = AppiumServer.new(@appium_args)
      @appium_args = nil
      @appium_args = @appium_server.appium_args
    end

    def start
      @vd_ctl.start(sleep_duration: 10)
      start_appium_server
    end

    def stop
      @vd_ctl.shutdown
      @appium_server.kill_appium_server
    end

    def erase_and_start
      @appium_server.kill_appium_server
      @vd_ctl.erase
      start_appium_server
    end

    def quit
      stop
      @vd_ctl.delete
    end
  end
end
