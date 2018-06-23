require 'base64'

class Token
  def self.from_b64 string
    new Base64.strict_decode64 string
  end

  def initialize bytes = RbNaCl::Random.random_bytes(32)
    @bytes = bytes
    @b64 = Base64.strict_encode64 bytes
  end

  attr_reader :bytes

  def to_s
    @b64
  end

  def valid?
    @bytes.size == 32 && @b64.size == 44
  end
end
