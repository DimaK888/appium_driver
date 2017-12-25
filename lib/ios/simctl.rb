module IOS
  class SimCtl
    class << self
      def simctl
        '/Applications/Xcode.app/Contents/Developer/usr/bin/simctl'
      end

      def simulator_app
        '/Applications/Xcode.app/Contents/Developer/Applications/Simulator.app/'
      end

      def create_vd(opts)
        ios_v = opts[:platform_version].gsub('.', '-')
        device_name = opts[:device_name].gsub(' ', '-')
        sim_name = "#{device_name}_ios#{ios_v}"

        puts "Create simulator #{sim_name}"

        cmd = "#{simctl} create #{sim_name}"
        cmd << " com.apple.CoreSimulator.SimDeviceType.#{device_name}"
        cmd << " com.apple.CoreSimulator.SimRuntime.iOS-#{ios_v}"

        print 'Simulator UDID: '
        p `#{cmd}`[0..-2]
      end

      def start_vd(opts)
        puts "Runing simulator UDID: #{opts[:udid]}"

        cmd = "#{simctl} boot #{opts[:udid]} ;"
        cmd << "open #{simulator_app}"

        system(cmd)
      end

      def shutdown_vd(udid)
        puts "Shutdown simulator UDID: #{udid}"

        system("#{simctl} shutdown #{udid}") unless udid.to_s.empty?
      end

      def delete_vd(opts)
        puts "Delete simulator UDID: #{opts[:udid]}"

        system("#{simctl} delete #{opts[:udid]}") unless opts[:udid].to_s.empty?
      end

      def list_of_running_vd
        system("#{simctl} list | grep Booted")
      end
    end
  end
end
