module AppiumDriver
  module ServerManager
    LOCALHOST = '127.0.0.1'.freeze

    def port_open?(port, ip: LOCALHOST)
      Timeout.timeout(1) do
        TCPSocket.new(ip, port).close
        true
      end
    rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, Timeout::Error
      false
    end

    def search_free_port(range_ports, ip: LOCALHOST)
      range_ports.step(4) do |port|
        return port unless port_open?(port, ip: ip)
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
