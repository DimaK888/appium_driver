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

    def simctl
      '/Applications/Xcode.app/Contents/Developer/usr/bin/simctl'
    end

    def simulator_app
      '/Applications/Xcode.app/Contents/Developer/Applications/Simulator.app/'
    end

    def create_vd
      puts "Create simulator #{@sim_name}"

      cmd = "#{simctl} create #{@sim_name}"
      cmd << " com.apple.CoreSimulator.SimDeviceType.#{@device_name.gsub(' ', '-')}"
      cmd << " com.apple.CoreSimulator.SimRuntime.iOS-#{@platform_version.gsub('.', '-')}"

      print 'Simulator UDID: '
      p `#{cmd}`[0..-2]
    end

    def start_vd
      puts "Runing simulator UDID: #{@udid}"

      cmd = "#{simctl} boot #{@udid} ; open #{simulator_app}"

      system(cmd)

      sleep(30)
    end

    def shutdown_vd
      puts "Shutdown simulator UDID: #{@udid}"

      system("#{simctl} shutdown #{@udid}") unless @udid.to_s.empty?
    end

    def delete_vd
      puts "Delete simulator UDID: #{@udid}"

      system("#{simctl} delete #{@udid}") unless @udid.to_s.empty?
    end

    def list_of_running_vd
      system("#{simctl} list | grep Booted")
    end
  end
end
