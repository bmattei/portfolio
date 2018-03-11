require 'rubygems'
require 'oauth'
require 'date'
require 'yaml'

# Format of auth.yml:
# consumer_key: (from osm.org)
# consumer_secret: (from osm.org)
# token: (use oauth setup flow to get this)
# token_secret: (use oauth setup flow to get this)

# issued when the application is registered with the site. Use your own.

ETRADE_KEY='4ec7afd53c54bbd92fcf6ac52c72c4f7'
ETRADE_SECRET='a4164ad86bb63633af13adc2caecd6c8'
ETRADE_TOKEN_PATH="https://etws.etrade.com/oauth/request_token"

consumer=OAuth::Consumer.new( ETRADE_KEY,    ETRADE_SECRET,    {:site=>ETRADE_TOKEN_PATH})

request_token = consumer.get_request_token

puts request_token
                              
