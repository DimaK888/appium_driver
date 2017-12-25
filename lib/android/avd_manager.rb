module Android
  class AVDManager
    class << self
      def create_vd(opts)
        android_v = opts[:platform_version]
        device_id = opts[:device_id]
        sdk_v = SDKManager.sdk_version(android_v)
        avd_port = opts[:avd_args][:port]
        avd_name = "avd_v#{sdk_v}_#{avd_port}"

        if vd_exists?(avd_name)
          puts "Emulator with name: #{avd_name} already exists"
          delete_vd({ avd_name: avd_name })
        end

        puts "Create emulator with name: #{avd_name} and sdk: #{sdk_v}"

        cmd = '$ANDROID_HOME/tools/bin/avdmanager create avd'
        cmd << " -n #{avd_name}"
        cmd << " -d #{device_id}"
        cmd << " -k \"system-images;android-#{sdk_v};google_apis;x86\""

        unless system(cmd)
          SDKManager.update_sdk
          SDKManager.install_sdk(sdk_v)
          system(cmd)
        end

        "emulator-#{avd_port}"
      end

      def vd_exists?(avd_name)
        !`$ANDROID_HOME/tools/bin/avdmanager list avd | grep 'Name: #{avd_name}'`.empty?
      end

      def device_name(id)
        `$ANDROID_HOME/tools/bin/avdmanager list device | grep 'id: #{id} or'`.split("\"")[1]
      end

      def start_vd(opts)
        sdk_v = SDKManager.sdk_version(opts[:platform_version])
        avd_port = opts[:avd_args][:port]
        avd_name = "avd_v#{sdk_v}_#{avd_port}"

        cmd = "$ANDROID_HOME/tools/emulator -avd #{avd_name} -port #{avd_port}"
        puts cmd
        pid = spawn(cmd, out: '/dev/null')
        Process.detach(pid)
        sleep(30)
      end

      def shutdown_vd(udid)
        system("adb -s #{udid} emu kill") unless udid.to_s.empty?

        50.times do
          ServerManager.port_open?(udid.split('-')[1]) ? sleep(2) : break
        end

        sleep(7)
      end

      def delete_vd(opts)
        puts "Delete emulator with name: #{opts[:avd_name]}"

        unless opts[:avd_name].to_s.empty?
          system("$ANDROID_HOME/tools/bin/avdmanager delete avd -n #{opts[:avd_name]}")
        end
      end
    end
  end
end
