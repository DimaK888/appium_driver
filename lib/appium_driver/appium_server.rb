module AppiumDriver
  class AppiumServer
    class << self
      def start_appium_server(args)
        puts 'Run Appium server'

        cmd = "cd $APPIUM_HOME ; node ."
        cmd << assembly_appium_args(args)
        puts cmd

        pid = spawn(cmd, out: '/dev/null')
        Process.detach(pid)

        50.times do
          ServerManager.port_open?(args[:port]) ? break : sleep(2)
        end
      end

      def assembly_appium_args(args)
        args = args.dup

        delete_args = [:device_id]

        delete_args +=
          if args[:platform_name] == 'ios'
            [ :bootstrap_port, :suppress_adb_kill_server, :reboot, :avd_args, :avd ]
          else
            [ :ipa, :force_iphone, :force_ipad, :webkit_debug_proxy_port,
            :instruments, :tracetemplate, :safari, :backend_retries, :udid ]
          end

        delete_args.each { |key| args.delete(key) }

        args_str = ''
        args.each do |key, value|
          next if key.to_s.empty? || value.to_s.empty?
          args_str <<
            case key
            when :avd_args
              str = " --avd-args \""
              value.each { |k, v| str << " -#{k.to_s.gsub('_', '-')} #{v}" }
              str << "\""
            else
              " --#{key.to_s.gsub('_', '-')} \"#{value}\""
            end
        end
        args_str
      end

      def kill_appium_server(port)
        ServerManager.kill_process_at_port(port)
      end
    end
  end
end
