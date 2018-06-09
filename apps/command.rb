class Command
  include Hobby

  post do
    preamble = request.body.read 80
    body = request.body.read 1024000

    hpk, nonce = preamble.split("\r\n").map(&:from_b64)
    ctext = body.from_b64

    @session_key, @client_key = SESSION_KEYS[hpk], CLIENT_KEYS[hpk]
    box = RbNaCl::Box.new @client_key, @session_key
    data = JSON.parse box.decrypt(nonce, ctext).force_encoding('utf-8'),
      symbolize_names: true

    rsp_nonce = _make_nonce
    cmd = data[:cmd]

    case cmd
    when 'upload'
      upload hpk, data
    when 'download'
      render_encrypted rsp_nonce, download(hpk, data)
    end
  end


  class Mailbox
    def initialize hpk
      @hpk = hpk
    end

    def store from, nonce, message
      nonce_in_b64 = nonce.to_b64

      item = {
        from: from.to_b64,
        nonce: nonce_in_b64,
        data: message.to_b64,
        time: Time.new.to_f,
        kind: :message.to_s.to_b64,
      }

      MESSAGES[msg_tag nonce_in_b64] = item.to_json

      storage_record = {
        hpk: @hpk,
        nonce: nonce_in_b64,
      }

      storage_token = h2 "#{@hpk}#{nonce_in_b64}"
    end

    # redis hash of all messages to given hpk
    def hpk_tag
      "msg_#{@hpk}"
    end

    # redis key for specific message to hpk
    def msg_tag nonce_in_b64
      "msg_#{@hpk}_#{nonce_in_b64}"
    end

    # message storage token that can be inspected later by sender
    def token_tag token
      "token_#{token.to_b64}"
    end
  end

  def upload hpk, data
    mailbox = Mailbox.new data[:to]

    message = data[:payload]
    nonce = _make_nonce

    mailbox.store(hpk, nonce, message).to_b64
  end

  def download _hpk, _data
    []
  end


  def render_encrypted nonce, data
    enc_payload = encrypt_data(nonce, data)
    "#{nonce.to_b64}\r\n#{enc_payload}"
  end

  def encrypt_data(nonce, data)
    box = RbNaCl::Box.new(@client_key, @session_key)
    box.encrypt(nonce, data.to_json).to_b64
  end
end
