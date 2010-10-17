$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rack/tunnel'
require 'realweb'
require 'rack/client'
require 'json'

RSpec.configure do |config|
  config.color_enabled = true

  config.before(:all) do
    @server = RealWeb.start_server_in_thread(File.join(File.dirname(__FILE__), 'config.ru'))
    @client = Rack::Client.new("http://127.0.0.1:#{@server.port}")
  end
end

