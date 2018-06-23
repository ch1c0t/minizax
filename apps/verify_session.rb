class VerifySession
  include Hobby

  post do
    body = request.body.read 90

    if body
      begin
        lines = body.split("\r\n").map(&:from_b64)
        fail unless lines.size == 2
        h2_of_client_token, h2_sign = lines
      rescue
        response.status = 400
        halt
      end

      if valid_handshake? h2_of_client_token, h2_sign
        session_key = make_session_key h2_of_client_token
        session_key.public_key.to_bytes.to_b64
      else
        response.status = 401
      end
    else
      response.status = 400
    end
  end

  def valid_handshake? h2_of_client_token, h2_sign
    client_token = CLIENT_TOKENS[h2_of_client_token]
    relay_token = RELAY_TOKENS[h2_of_client_token]

    if client_token && relay_token
      correct_sign = h2(client_token + relay_token)
      h2_sign == correct_sign
    end
  end

  def make_session_key h2_of_client_token
    session_key = RbNaCl::PrivateKey.generate
    SESSION_KEYS[h2_of_client_token] = session_key
  end
end
