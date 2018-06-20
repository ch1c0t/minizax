class StartSession
  include Hobby

  post do
    client_token = request.body.read 44

    if client_token
      relay_token = Base64.strict_encode64 RbNaCl::Random.random_bytes 32
      difficulty = 0

      "#{relay_token}\r\n#{difficulty}"
    else
      response.status = 400
    end
  end
end
