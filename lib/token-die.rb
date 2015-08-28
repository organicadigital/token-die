require 'parsel'
class TokenDie
  TIMESTAMP_KEY = '___timestamp____'.freeze

  # Set the encryption secret
  attr_reader :secret

  # Set the token TTL
  # Defaults 300 (5 minutes)
  attr_reader :ttl

  # Set the encryptor strategy.
  # Defaults Parsel::JSON
  attr_reader :encryptor

  def initialize(secret, ttl = 300, encryptor = Parsel::JSON)
    @secret = secret
    @ttl = ttl
    @encryptor = encryptor
  end

  def generate(data = {})
    timestamp = Time.now.to_i
    data.merge!(TIMESTAMP_KEY => timestamp)

    encryptor.encrypt(secret, data)
  end

  def recover(token)
    data = encryptor.decrypt(secret, token)
    return unless data
    return unless fresh?(data[TIMESTAMP_KEY])

    data.delete(TIMESTAMP_KEY)
    data
  end

  def valid?(token)
    !recover(token).nil?
  end

  def expired?(timestamp)
    timestamp.to_i < (Time.now.to_i - ttl)
  end

  def fresh?(timestamp)
    !expired?(timestamp)
  end
end