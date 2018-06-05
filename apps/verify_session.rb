class VerifySession
  include Hobby

  post do
    body = request.body.read 90

    lines = body.split("\r\n").map do |line|
      Base64.strict_decode64 line
    end

    #verify_handshake lines
    session_key = make_session_key lines.first
    Base64.strict_encode64 session_key.public_key.to_bytes
  end

  def verify_handshake lines
    h2_of_client_token, client_sign = lines

    client_token = CLIENT_TOKENS[h2_client_token]
    relay_token = RELAY_TOKENS[h2_client_token]

    correct_sign = h2(client_token + relay_token)

    if client_sign.eql? correct_sign
      [client_token, h2_of_client_token]
    end
  end

  def make_session_key h2_of_client_token
    session_key = RbNaCl::PrivateKey.generate
    SESSION_KEYS[h2_of_client_token] = session_key
  end
end
