# TokenDie

Generate and validate time expiring tokens

## Usage

```ruby
secret = 'my-secret' #=> Secret token
ttl = 5 #=> Token TTL, default 300 (5 minutes)

token_die = TokenDie.new(secret, ttl = ttl)

token = token_die.generate #=> haNSO3ArFzE/2Jm2KQPkyWEaV0wX5dK7HbaYYEmyX/k=
token_die.valid?(token) #=> true
token_die.recover(token) #=> {}

# Passing Data
token_with_data = token_die.generate({'foo' => 'bar'}) #=>JzJW02mJsJDNFH+jMGMmhFLigHie+j/gCZh60dI7LBsf3z73kAMh/+ZtQTgWbxE7
token_die.valid?(token_with_data) #=> true
token_die.recover(token_with_data) #=> {"foo" => "bar"}

sleep(ttl) #=> When TTL expires

token_die.valid?(token) #=> false
token_die.recover(token) #=> nil
token_die.recover(token_with_data) #=> nil

```