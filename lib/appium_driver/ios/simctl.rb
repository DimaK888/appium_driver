module AppiumDriver
  module IOS
    module SimCtl
      def simctl
        '/Applications/Xcode.app/Contents/Developer/usr/bin/simctl'
      end

      def simulator_app
        '/Applications/Xcode.app/Contents/Developer/Applications/Simulator.app/'
      end

      def create_sim
        puts "Create simulator #{@avd_name} with iOS #{@sdk_version}"

        ios_v = @sdk_version.sub('.', '-')

        cmd = "#{simctl} create #{@avd_name}"
        cmd << " com.apple.CoreSimulator.SimDeviceType.#{@avd_device}"
        cmd << " com.apple.CoreSimulator.SimRuntime.iOS-#{ios_v}"

        `#{cmd}`[0..-2]
      end

      def run_simulator
        puts "Runing simulator with UUID: #{@uuid}"

        cmd = "#{simctl} boot #{@uuid} ;"
        cmd << "open #{simulator_app}"

        system(cmd)
      end

      def shutdown_simulator
        puts "Shutdown simulator with UUID: #{@uuid}"

        system("#{simctl} shutdown #{@uuid}")
      end

      def delete_simulator
        puts "Delete simulator with UUID: #{@uuid}"

        system("#{simctl} delete #{@uuid}")
      end

      def running_simulator_list
        system("#{simctl} list | grep Booted")
      end
    end
  end
end