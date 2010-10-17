dir = File.dirname(__FILE__)
$:.unshift dir + '/lib'

require 'rack/tunnel'

Gem::Specification.new do |s|
  s.name        = 'rack-tunnel'
  s.version     = Rack::Tunnel::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Ben Burkert']
  s.email       = ['ben@benburkert.com']
  s.homepage    = 'http://github.com/benburkert/rack-tunnel'
  s.summary     = "Automatic port forwading via SSH tunneling."
  s.description = s.summary

  s.add_dependency 'rack'
  s.add_dependency 'open4'

  s.add_development_dependency 'rack-client', '>=0.3.1.pre.b'
  s.add_development_dependency 'json'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'realweb'
  s.add_development_dependency 'rake'

  s.files         = Dir["#{dir}/lib/**/*.rb"]
  s.require_paths = ["lib"]

  s.test_files    = Dir["#{dir}/spec/**/*.rb"]
end
