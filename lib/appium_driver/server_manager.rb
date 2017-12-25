module AppiumDriver
  module ServerManager
    def port_open?(port, ip = '127.0.0.1')
      Timeout.timeout(1) do
        TCPSocket.new(ip, port).close
        return true
      end
    rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
      return false
    rescue Timeout::Error
      return false
    end

    def search_free_port(range_ports, ip = '127.0.0.1')
      range_ports.step(4) do |port|
        return port unless port_open?(port, ip)
      end
    end

    def kill_process_at_port(port)
      process_ids = `lsof -t -i:#{port}`.split("\n")
      process_ids.each do |process_id|
        `kill #{process_id}`
      end
    end
  end
end
