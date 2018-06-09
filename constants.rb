CLIENT_TOKENS = {}
RELAY_TOKENS = {}

SESSION_KEYS = {}
CLIENT_KEYS = {}

MESSAGES = Hash.new do |hash, key|
  hash[key] = {}
end
