class Prove
  include Hobby

  post do
    # We expect 4 lines, base64 each:
    # 1: h₂(client_token): client_token used to receive a relay session pk
    # 2: a_temp_pk : client temp session key
    # 3: nonce_outter: timestamped nonce
    # 4: crypto_box(JSON, nonce_inner, relay_session_pk, client_temp_sk): Outer crypto-text
    body = request.body.read 382
    l1, l2, l3, l4 = body.split("\r\n").map(&:from_b64)

    h2_ct, client_temp_pk, nonce_outer, ctext = l1, l2, l3, l4
    session_key = SESSION_KEYS[h2_ct]

    outer_box = RbNaCl::Box.new client_temp_pk, session_key
    inner = JSON.parse(outer_box.decrypt nonce_outer, ctext).map do |k, v|
      [k.to_sym, v.from_b64]
    end.to_h

    hpk = h2 inner[:pub_key]
    SESSION_KEYS[hpk] = session_key
    CLIENT_KEYS[hpk] = client_temp_pk
    1 # Mailbox#count
  end
end
