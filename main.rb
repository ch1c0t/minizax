require 'puma'
require 'rbnacl'
require 'base64'
require 'hobby'
require 'hobby/cors'

require_relative 'apps/start_session'

class Root
  include Hobby

  use Cors

  map '/start_session', StartSession.new
end

server = Puma::Server.new Root.new
server.add_tcp_listener '127.0.0.1', 8080
server.run
sleep
