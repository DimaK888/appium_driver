module AppiumDriver
  # appium_args = {
  #   port: 4723,
  #   platform_name: 'android',
  #   platform_version: '7.1',
  #   device_name: 'Nexus 5X',
  #   app: 'path/to/apk',
  #   avd: 'avd_v25_5556',
  #   avd_args: {port: 5556},
  #   udid: 'emulator-5556',
  #   no_reset: false,
  #   full_reset: false,
  #   app_wait_package: 'package.',
  #   app_wait_activity: 'activity.'
  # }

  attr_accessor :appium_args
  attr_accessor :device_name
  attr_accessor :vd_port
  attr_accessor :vd_name
  attr_accessor :udid

  def start(appium_args = {})
    raise('$ANDROID_HOME not available') if `echo $ANDROID_HOME`.empty?
    raise('$APPIUM_HOME not available') if `echo $APPIUM_HOME`.empty?

    @appium_args = appium_args
    @appium_server = AppiumServer
    @appium_args[:port] = ServerManager.search_free_port(4723..4787)

    @appium_args[:platform_name] ||= 'android'
    @appium_args[:platform_name].downcase!

    if @appium_args[:platform_name] == 'android'
      @appium_args[:platform_version] ||= '7.1'
      @vd_ctl = Android::AVDManager
      @appium_args[:device_id] = @appium_args[:device_name] ||= 9 # Nexus 5X
      @appium_args[:device_name] = @vd_ctl.device_name(@appium_args[:device_id])
      @avd_port = ServerManager.search_free_port(5556..5620)
      @appium_args[:avd_args] = { port: @avd_port }
    else
      @vd_ctl = IOS::SimCtl
      @appium_args[:platform_version] ||= '11.2'
      @appium_args[:device_name] ||= 'iPhone 5s'
    end

    @appium_args[:udid] = @vd_ctl.create_vd(@appium_args)

    @vd_ctl.start_vd(@appium_args)
    @appium_server.start_appium_server(@appium_args)
  end

  def stop
    @vd_ctl.shutdown_vd(@appium_args[:udid])
    @vd_ctl.delete_vd(@appium_args)
    @appium_server.kill_appium_server(@appium_args[:port])
  end

  def kill_all
    kill_all_emulators
    kill_all_appium_servers
  end

  def kill_all_appium_servers
    (4723..4787).each do |port|
      ServerManager.port_open?(port) && ServerManager.kill_process_at_port(port)
    end
  end

  def kill_all_emulators
    emulator_list = `adb devices | grep emulator | cut -f1`.split("\n")
    emulator_list.each do |name|
      `adb -s #{name} emu kill`
    end
  end
end
