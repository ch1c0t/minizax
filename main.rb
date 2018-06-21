require 'puma'
require 'rbnacl'
require 'base64'
require 'json'
require 'hobby'
require 'hobby/cors'

require_relative 'for_reference/key_params'
include KeyParams

require_relative 'for_reference/utils'
require_relative 'errors/all'

require_relative 'constants'
require_relative 'helpers'
require_relative 'token'

require_relative 'apps/start_session'
require_relative 'apps/verify_session'
require_relative 'apps/prove'
require_relative 'apps/command'

class Root
  include Hobby

  use Cors

  map '/start_session', StartSession.new
  map '/verify_session', VerifySession.new
  map '/prove', Prove.new
  map '/command', Command.new
end

HOST = '127.0.0.1'
PORT = 8080
server = Puma::Server.new Root.new
server.add_tcp_listener HOST, PORT
server.run
puts "Started at #{HOST}:#{PORT}."
sleep
