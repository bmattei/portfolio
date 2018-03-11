require 'oauth'
@consumer = OAuth::Consumer.new(key, secret, {
  :site               => "",
  :scheme             => :header,
  :http_method        => :post,
  :request_token_path => "/oauth/request_token",
  :access_token_path  => "/oauth/example/access_token.php",
  :authorize_path     => "/oauth/example/authorize.php"
 })
