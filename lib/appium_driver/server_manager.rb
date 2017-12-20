module AppiumDriver
  module ServerManager
    def port_open?(ip, port)
      Timeout.timeout(1) do
        TCPSocket.new(ip, port).close
        return true
      end
    rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
      return false
    rescue Timeout::Error
      return false
    end

    def search_free_port(range_ports, ip)
      range_ports.step(4) do |p|
        unless port_open?(ip, p)
          @port = p
          break
        end
      end
      @port
    end

    def kill_process_at_port(port)
      process_ids = `lsof -t -i:#{port}`.split("\n")
      process_ids.each do |process_id|
        `kill #{process_id}`
      end
    end
  end
end
