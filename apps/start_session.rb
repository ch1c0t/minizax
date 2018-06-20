class StartSession
  include Hobby

  post do
    b64_client_token = request.body.read 44
    client_token = if b64_client_token&.size == 44
                     b64_client_token.from_b64
                   end

    if b64_client_token
      if client_token&.size == 32
        relay_token = Base64.strict_encode64 RbNaCl::Random.random_bytes 32
        difficulty = 0

        "#{relay_token}\r\n#{difficulty}"
      else
        response.status = 401
      end
    else
      response.status = 400
    end
  end
end
