module AppiumDriver
  class AppiumServer
    attr_reader :appium_args

    DEFAULT_APPIUM_PORTS = 4723..4787

    def initialize(appium_args)
      appium_args[:port] = search_free_port(DEFAULT_APPIUM_PORTS)
      @appium_args = appium_args

      start_appium_server
    end

    def start_appium_server
      puts 'Run Appium server'

      cmd = 'cd $APPIUM_HOME ; node .'
      cmd << assembly_appium_args
      puts cmd

      pid = spawn(cmd, out: '/dev/null')
      Process.detach(pid)

      30.times do
        port_open?(@appium_args[:port]) ? break : sleep(1)
      end
    end

    def kill_appium_server
      kill_process_at_port(@appium_args[:port])
    end

    def assembly_appium_args
      args = @appium_args.dup

      delete_args(args).each { |key| args.delete(key) }

      args_str = ''
      args.each do |key, value|
        next if key.to_s.empty? || value.to_s.empty?
        args_str <<
          case key
          when :avd_args
            str = ' --avd-args "'
            value.each { |k, v| str << " -#{k.to_s.tr('_', '-')} #{v}" }
            str << '"'
          else
            " --#{key.to_s.tr('_', '-')} \"#{value}\""
          end
      end
      args_str
    end

    def delete_args(args)
      if args[:platform_name].downcase == 'ios'
        %i[
          device_id
          bootstrap_port
          suppress_adb_kill_server
          reboot
          avd_args
          avd
          sdk_version
        ]
      else
        %i[
          ipa
          force_iphone
          force_ipad
          webkit_debug_proxy_port
          instruments
          tracetemplate
          safari
          backend_retries
          udid
        ]
      end
    end

    def self.kill_all_appium_servers
      DEFAULT_APPIUM_PORTS.each do |port|
        port_open?(port) && kill_process_at_port(port)
      end
    end
  end
end
