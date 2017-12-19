module AppiumDriver
  module ServerManager
    include Errno

    def port_open?(ip, port)
      Timeout.timeout(1) do
        TCPSocket.new(ip, port).close
        return true
      end
    rescue ECONNREFUSED, EHOSTUNREACH
      return false
    rescue Error
      return false
    end

    def search_free_port(range_ports, ip, step = 2)
      range_ports.step(step) do |p|
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
