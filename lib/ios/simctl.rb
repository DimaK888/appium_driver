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
      @sim_name = "#{@device_name.tr(' ', '-')}_ios#{@platform_version.tr('.', '-')}"
      @udid = create
    end

    def create
      puts "Create simulator #{@sim_name}"

      cmd = "#{self.class.simctl} create #{@sim_name}"
      cmd << " com.apple.CoreSimulator.SimDeviceType.#{@device_name.tr(' ', '-')}"
      cmd << " com.apple.CoreSimulator.SimRuntime.iOS-#{@platform_version.tr('.', '-')}"

      print 'Simulator UDID: '
      p `#{cmd}`[0..-2]
    end

    def start(sleep_duration: 30)
      puts "Running simulator UDID: #{@udid}"

      system("#{self.class.simctl} boot #{@udid}")
      system("open #{self.class.simulator_app}")

      sleep(sleep_duration)
    end

    def shutdown
      self.class.shutdown(@udid)
    end

    def delete
      self.class.delete(@udid)
    end

    def erase
      shutdown
      if system("#{self.class.simctl} erase  #{@udid}")
        puts "Simulator UDID: #{@udid} is erased"
      end
      sleep(2)
      start
    end

    class << self
      def shutdown(udid)
        if udid_list_of_booted_simulators.include?(udid)
          puts "Shutdown simulator UDID: #{udid}"
          system("#{simctl} shutdown #{udid}")
        else
          puts "Simulator UDID: #{udid} already shutdown"
        end
      end

      def delete(udid)
        if simulator_list.map { |sim| sim['udid'] }.include?(udid)
          puts "Delete simulator UDID: #{udid}"
          system("#{simctl} delete #{udid}")
        else
          puts "Simulator UDID: #{udid} already deleted"
        end
      end

      def kill_all_booted_simulators
        udid_list_of_booted_simulators.each do |udid|
          shutdown(udid)
          delete(udid)
        end
      end

      def udid_list_of_booted_simulators
        search_simulators('state' => 'Booted').map { |sim| sim['udid'] }
      end

      def search_simulators(param)
        simulator_list.select { |sim| sim.to_a.include?(param.to_a.first) }
      end

      def simulator_list
        list = JSON.parse(`#{simctl} list devices -j`)['devices']
        list.delete_if { |device_type, _| !device_type.include?('iOS ') }

        @devices_list = []

        list.map do |ios_version, devices_list|
          devices_list.map do |device|
            @devices_list << device.merge!('ios' => ios_version.split.last)
          end
        end

        @devices_list
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
