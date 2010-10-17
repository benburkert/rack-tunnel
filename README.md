rack/tunnel
===========

Automatic port forwading via SSH tunneling.

example
-------

config.ru

    require 'rack/tunnel'

    use Rack::Tunnel, 'http://root@localhost'
    run lambda {|env| [200, {'Content-Type' => 'text/plain'}, [env['X-Tunnel-Uri']]] }

rackup

    % rackup config.ru -P 9292

irb

    >> require 'rack/client'
    => true
    >> uri = Rack::Client.new("http://localhost:9292/").get("/").body
    => <tunnel_url>
    >> Rack::Client.new(uri).get('/').status
    => 200
