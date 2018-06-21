class StartSession
  include Hobby

  post do
    body = request.body.read 44

    if body
      begin
        client_token = Token.from_b64 body
      rescue ArgumentError # if the body contains invalid base64
        response.status = 401
        halt
      end

      if client_token.valid?
        relay_token, difficulty = Token.new, 0
        "#{relay_token}\r\n#{difficulty}"
      else
        response.status = 401
      end
    else
      response.status = 400
    end
  end
end
