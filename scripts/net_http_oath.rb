require 'net/http'
require 'openssl'
require 'base64'

def sign( key, base_string )
  digest = OpenSSL::Digest::Digest.new( 'sha1' )
  # hmac = OpenSSL::HMAC.digest( digest, key, base_string  )
  hmac = OpenSSL::HMAC.digest( digest, base_string, key  )
  Base64.encode64( hmac ).chomp.gsub( /\n/, '' )
end

ETRADE_KEY='4ec7afd53c54bbd92fcf6ac52c72c4f7'
ETRADE_SECRET='a4164ad86bb63633af13adc2caecd6c8'
ETRADE_ROUTE = "https://etws.etrade.com/oauth/request_token"
uri = URI(ETRADE_ROUTE)

base_string = "GET&#{ETRADE_ROUTE}&application_Id%3D{applicationId}%26body%3D{requestBody}%26oauth_consumer_key%3D{consumerKey}%26oauth_nonce%3D{nonce}%3Doauth_signature_method%3D{hashMethod}%26oauth_timestamp%3D{timestamp}
params = {oauth_consumer_key: ETRADE_KEY,
          oauth_timestamp:	Time.now.getutc.to_i,
          oauth_nonce:	Time.now.getutc,
          oauth_signature_method: "HMAC-SHA1",
          oauth_signature:	sign(ETRADE_KEY, ETRADE_SECRET),
          oauth_callback: "oob"

         }

uri.query = URI.encode_www_form(params)

res = Net::HTTP.get_response(uri)

puts res.body
