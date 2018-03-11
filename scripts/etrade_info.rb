#!/usr/bin/env ruby
$LOAD_PATH << '.'
require 'rubygems'
require 'mysql2'
require 'config/environment.rb'
# require 'comsumer_token'
require 'byebug'
# ETRADE_PATH = "https://etwssandbox.etrade.com"
# ETRADE_REQ_SUBPATH = '/accounts/sandbox/rest/'
ETRADE_PATH = "https://etws.etrade.com"
ETRADE_REQ_SUBPATH = '/accounts/rest/'
class EtradeInfo
  # Cosumer_tokne is defined in controller/concerns
  def initialize()
    @consumer = OAuth::Consumer.new(CONSUMER_TOKEN[:token],CONSUMER_TOKEN[:secret],{:site => ETRADE_PATH, :http_method => :get})
    @request_token = @consumer.get_request_token()
    @url = "https://us.etrade.com/e/t/etws/authorize?key=#{OAuth::Helper.escape(CONSUMER_TOKEN[:token])}&token=#{OAuth::Helper.escape(@request_token.token)}"
    system("open", @url)
    puts "Once you have authorized this app, enter your pin here and press enter:"
    pin = $stdin.readline().chomp
    access = @consumer.get_access_token(@request_token,{:oauth_verifier => pin})
    @access_token = OAuth::Token.new(access.token, access.secret)
  end


  def get_account_list
    result = @consumer.request(:get, "#{ETRADE_REQ_SUBPATH}accountlist.json", @access_token)
    # puts result.body
    # puts JSON.parse(result.body)
    account_list =  JSON.parse(result.body)['json.accountListResponse']['response']
    puts account_list
    account_list

  end

  def get_account_balance(account)
    id = account['accountId']
    url = "#{ETRADE_REQ_SUBPATH}/accountbalance/#{id}.json"
    
    result = @consumer.request(:get, url, @access_token)
    puts result.body
    puts JSON.parse(result.body)
  end



end

if __FILE__ == $0
  etrade = EtradeInfo.new
  account_list = etrade.get_account_list
  account_list.each do |account|
    etrade.get_account_balance(account)
  end
end
