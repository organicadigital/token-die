require 'spec_helper'
require 'securerandom'

describe TokenDie do
  let(:secret) { SecureRandom.hex }
  let(:token_die) { TokenDie.new(secret) }

  describe '#expired?' do
    let(:ttl) { 60 * 5 }
    let(:token_die) { TokenDie.new(secret, ttl) }

    it 'validates that timestamp is fresh' do
      expect(token_die.expired?(Time.now.to_i)).to be_falsy
      expect(token_die.expired?(Time.now.to_i - ttl)).to be_falsy
      expect(token_die.expired?(Time.now.to_i - ttl - 1)).to be_truthy
    end
  end

  describe '#generate' do
    it 'returns a tokenized data' do
      token = token_die.generate
      expect(token).to_not be_nil
      expect(token).to be_kind_of(String)

      token_with_data = token_die.generate('app' => 'hello')
      expect(token_with_data).to_not be_nil
      expect(token_with_data).to be_kind_of(String)
    end
  end

  describe '#recover' do
    let(:token) { token_die.generate }
    let(:token_with_data) { token_die.generate('app' => 'hello') }

    it 'returns empty hash without data' do
      expect(token_die.recover(token)).to be_eql({})
    end

    it 'returns data and timestamp with valid token' do
      data = token_die.recover(token_with_data)

      expect(data).to be_eql('app' => 'hello')
    end

    it 'returns nil with invalid token' do
      expect(token_die.recover('an-invalid-token')).to be_nil
    end

    it 'returns nil with expired token' do
      allow(token_die).to receive(:expired?) { true }

      expect(token_die.recover(token_with_data)).to be_nil
    end
  end

  describe '#valid?' do
    let(:token) { token_die.generate }
    let(:token_with_data) { token_die.generate('app' => 'hello') }

    it 'check that token is valid' do
      expect(token_die.valid?(token)).to be_truthy
      expect(token_die.valid?(token_with_data)).to be_truthy
      expect(token_die.valid?('invalid-token')).to be_falsy
    end
  end
end
