module AppiumDriver
  module AppiumServer
    class << self
      attr_writer :port

      def initialize(port)
        unless appium_home_available?
          raise('$APPIUM_HOME not available')
        end

        @port = port
      end

      def start_appium_server
        kill_process_at_port(@port)

        cmd = 'cd $APPIUM_PATH ;\ node .'\
        " --port #{@port} -U emulator-#{AVDManager.port}"

        puts cmd
        pid = spawn(cmd, :out => '/dev/null')
        Process.detach(pid)

        50.times do
          is_port_open?('0.0.0.0', @port) ? break : sleep(2)
        end
      end

      def kill_appium_server
        kill_process_at_port(@port)
      end
    end

    def appium_home_available?
      !`echo $APPIUM_HOME`.empty?
    end

    def kill_all_appium_servers
      (4723..4787).each do |port|
        is_port_open?('0.0.0.0', port) && kill_process_at_port(p)
      end
    end
  end
end
