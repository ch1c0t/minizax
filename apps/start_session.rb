class StartSession
  include Hobby

  post do
    #client_token = request.body.read 44
    #p client_token
    relay_token = Base64.strict_encode64 RbNaCl::Random.random_bytes 32
    difficulty = 0

    response.add_header 'Access-Control-Allow-Origin', '*'
    "#{relay_token}\r\n#{difficulty}"
  end
end
