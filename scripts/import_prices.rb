#!/usr/bin/env ruby

$LOAD_PATH << '.'
$LOAD_PATH << './ETL'

require 'net/http'
require 'rubygems'
require 'mysql2'
require 'config/environment.rb'
require 'byebug'


class ImportPrices
  ApiKey = 'I50S'

  # Compact returns only last 10 data points
  
  def initialize(ticker, compact=true, daily=true)
    series = 'TIME_SERIES_DAILY'
    @data_key = "Time Series (Daily)"
    if !daily
      series = 'TIME_SERIES_WEEKLY'
      @data_key = "Weekly Time Series"
    end
    @ticker = ticker
    @compact = compact
    if compact
      @uri_str = "http://www.alphavantage.co/query?function=#{series}&symbol=#{ticker.upcase}&apikey=#{ApiKey}&outputsize=compact"
    else
      @uri_str = "http://www.alphavantage.co/query?function=#{series}&symbol=#{ticker.upcase}&apikey=#{ApiKey}"
    end
  end

    
  def import_prices
    uri = URI(@uri_str)
    resp = Net::HTTP.get_response(uri)
    prices = JSON.parse(resp.body)[@data_key]
  end

end


class ImportAllPrices
  DateIdx = 0
  PriceIdx = 1
  CloseKey = '4. close'
  def initialize(compact=true)
    @compact = compact
  end
  def import_all
    Ticker.all.each do |ticker|
      importer = ImportPrices.new(ticker.symbol)

      prices = importer.import_prices
      if prices
        prices.each do |x|
          date = x[DateIdx].to_date
          closing_price = x[PriceIdx][CloseKey]
          price = Price.where(ticker_id: ticker.id,
                              price_date: date).first_or_create(price: closing_price)
          
        end
      else
        puts "symbol not found #{ticker.symbol}"
      end
    end
  end
end

if __FILE__ == $0

  price_importer = ImportAllPrices.new()
  price_importer.import_all
  Account.all.each do |account|
    account.update_values
  end

end
