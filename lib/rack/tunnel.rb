require 'socket'
require 'uri'
require 'open4'

module Rack
  class Tunnel
    VERSION = '0.1.0'
    HEADER  = 'X-Tunnel-Uri'

    def initialize(app, uri)
      @app, @uri = app, URI.parse(uri)

      if @uri.port <= 1024 && @uri.user != 'root'
        raise Error, "root user required for port #{@uri.port}"
      end
    end

    def call(env)
      establish_tunnel(env['SERVER_PORT']) unless @tunnel_established
      @app.call(env.merge(HEADER => @uri.to_s))
    end

    def establish_tunnel(local_port)
      pid, _ = Open4.popen4(command(local_port))

      at_exit do
        Process.kill(9, pid)
        Process.wait
      end

			wait_for_tunnel
      @tunnel_established = true
    end

    def command(local_port)
      cmd = %w"ssh"
      cmd << "-R 0.0.0.0:#{@uri.port}:localhost:#{local_port}"
      cmd << @uri.host
      cmd << "-l #{@uri.user}"
      cmd << "-o TCPKeepAlive=yes"
      cmd << "-o ServerAliveInterval=30"
      cmd << "-o ServerAliveCountMax=10"
      cmd << "-o GatewayPorts=yes"
      cmd << "-N"

      cmd.join(' ')
    end

    def wait_for_tunnel
      Timeout::timeout(30) do
        begin
          return TCPSocket.new(@uri.host, @uri.port)
        rescue Errno::ECONNREFUSED
          retry
        rescue => e
          raise Error, e.message
        end
      end
    end

    class Error < StandardError ; end
  end
end
