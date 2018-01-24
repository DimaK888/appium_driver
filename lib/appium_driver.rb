require 'json'
require 'socket'
require 'timeout'

require 'android/sdk_manager'
require 'android/avd_manager'
require 'ios/simctl'
require 'appium_driver/version'
require 'appium_driver/server_manager'
require 'appium_driver/appium_server'
require 'appium_driver/driver'

include AppiumDriver

module AppiumDriver
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

  def symbolize_keys(hash)
    hash.each_with_object({}) do |(key, value), h|
      h[key.to_sym] = value.is_a?(Hash) ? symbolize_keys(value) : value
    end
  end
end
