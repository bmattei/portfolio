class ImportEtrade
  consumer = OAuth::Consumer.new(CONSUMER_TOKEN[:token],CONSUMER_TOKEN[:secret],{:site => "https://etws.etrade.com", :http_method => :get})
  request_token = consumer.get_request_token()
  auth_path = "https://us.etrade.com/e/t/etws/authorize?key=#{escape(CONSUMER_TOKEN[:token])}&token=#{escape(request_token.token)}"
  #
  # Scrape key.  We should do this with a callback - but I don't think I can callback
  # thru the mifi.
  #
  page = Nokogiri::HTML(open(auth_path))

  access_token = consumer.get_access_token(request_token,{:oauth_verifier => pin})



end
