require File.join(File.dirname(__FILE__), 'spec_helper')

describe Rack::Tunnel do
  it 'adds the "X-Tunnel-Uri" header' do
    env = JSON.parse(@client.get('/').body)
    env['X-Tunnel-Uri'].should =~ %r{^http://}
  end

  it 'tunnels over ssh' do
    env = JSON.parse(@client.get('/').body)
    uri = env['X-Tunnel-Uri']

    Rack::Client.new(uri).get('/').status.should == 200
  end

  it 'raise an exception if the port is restricted and the user is not root' do
    lambda {
      Rack::Client.new do
        use Rack::Tunnel, "http://#{ENV['USER']}@localhost"
        run lambda { [200, {}, []] }
      end
    }.should raise_error(Rack::Tunnel::Error)
  end
end
