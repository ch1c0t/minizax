class String
  def to_b64
    Base64.strict_encode64 self
  end

  def from_b64
    Base64.strict_decode64 self
  end
end

# h2(m) = sha256(sha256(64x0 + m))
# Zero out initial sha256 block, and double hash 0-padded message
# http://cs.nyu.edu/~dodis/ps/h-of-h.pdf
def h2(msg)
  RbNaCl::Hash.sha256 RbNaCl::Hash.sha256 "\0" * 64 + msg
end

# Create new NaCl nonce with timestamp. First 8 bytes is timestamp,
# the following 16 bytes are random.
def _make_nonce(tnow = Time.now.to_i)
  nonce = (rand_bytes NONCE_LEN).unpack "C#{NONCE_LEN}"

  timestamp = (Math.log(tnow)/Math.log(256)).floor.downto(0).map do
    |i| (tnow / 256 ** i) % 256
  end
  blank = Array.new(8) {0} # zero as 8 byte integer

  # 64 bit timestamp, MSB first
  blank[-timestamp.length, timestamp.length] = timestamp

  # Nonce first 8 bytes are timestamp
  nonce[0, blank.length] = blank
  return nonce.pack("C*")
end

def rand_bytes(count)
  RbNaCl::Random.random_bytes(count)
end
