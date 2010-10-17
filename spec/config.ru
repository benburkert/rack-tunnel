use Rack::Lint
use Rack::Tunnel, 'http://root@localhost'
use Rack::Lint

run lambda {|env| [200, {'Content-Type' => 'application/json'}, [env.to_json]] }
