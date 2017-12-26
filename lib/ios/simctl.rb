module IOS
  class SimCtl
    attr_reader :platform_name
    attr_reader :platform_version
    attr_reader :device_name
    attr_reader :udid
    attr_reader :sim_name

    def initialize(args = {})
      @platform_name = 'iOS'
      @platform_version = (args.fetch :platform_version, '11.2')
      @device_name = (args.fetch :device_name, 'iPhone 5s')
      @sim_name = "#{@device_name.gsub(' ', '-')}_ios#{@platform_version.gsub('.', '-')}"
      @udid = create_vd
    end

    def create_vd
      puts "Create simulator #{@sim_name}"

      cmd = "#{self.class.simctl} create #{@sim_name}"
      cmd << " com.apple.CoreSimulator.SimDeviceType.#{@device_name.gsub(' ', '-')}"
      cmd << " com.apple.CoreSimulator.SimRuntime.iOS-#{@platform_version.gsub('.', '-')}"

      print 'Simulator UDID: '
      p `#{cmd}`[0..-2]
    end

    def start_vd(sleep_duration = 30)
      puts "Running simulator UDID: #{@udid}"

      cmd = "#{self.class.simctl} boot #{@udid} ; open #{self.class.simulator_app}"

      system(cmd)

      sleep(sleep_duration)
    end

    def shutdown_vd
      self.class.shutdown_vd(@udid)
    end

    def delete_vd
      self.class.delete_vd(@udid)
    end

    class << self
      def shutdown_vd(udid)
        puts "Shutdown simulator UDID: #{udid}"

        system("#{simctl} shutdown #{udid}") unless udid.to_s.empty?
      end

      def delete_vd(udid)
        puts "Delete simulator UDID: #{udid}"

        system("#{simctl} delete #{udid}") unless udid.to_s.empty?
      end

      def udid_list_of_booted_simulators
        `#{simctl} list | grep Booted`.
          split("\n").
          map { |sim| sim.strip.split[1][1..-2] }
      end

      def kill_all_booted_simulators
        udid_list_of_booted_simulators.each do |udid|
          shutdown_vd(udid)
          delete_vd(udid)
        end
      end

      def simctl
        '/Applications/Xcode.app/Contents/Developer/usr/bin/simctl'
      end

      def simulator_app
        '/Applications/Xcode.app/Contents/Developer/Applications/Simulator.app/'
      end
    end
  end
end
