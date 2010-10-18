rack/tunnel
===========

Automatic port forwading via SSH tunneling.

setup
-----

Be sure to setup your ssh-agent for the SSH connection. If you plan on forwarding a well-known
port (e.g. 80), add `GatewayPorts=yes` to your sshd_config file (and restart sshd!).

The SSH tunnel will be established on the first request to the rack server.

example
-------

config.ru

    require 'rack/tunnel'

    use Rack::Tunnel, 'http://root@localhost'
    run lambda {|env| [200, {'Content-Type' => 'text/plain'}, [env['X-Tunnel-Uri']]] }

rackup

    % rackup config.ru -p 9292

irb

    >> require 'rack/client'
    => true
    >> Rack::Client.new("http://localhost:9292/").get("/").body
    => 'http://root@localhost'
    >> Rack::Client.new("http://localhost/").get('/').status
    => 200

contributors
------------

*   [Eric Lindvall](http://github.com/eric)
