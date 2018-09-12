
class ImportPrices
  ApiKey = 'I50S'

  # Compact returns only last 10 data points
  TIME_SERIES_DAILY = "Time Series (Daily)"

  def self.getLastPrice(symbol)
    symbol = symbol.upcase
    quote_list = self.getDaily(symbol)
    quote = nil
    if !quote_list.empty?
      quote = {}
      last_date = quote_list.keys.sort{|a, b| a <=> b }.last
      quote[:price]  = quote_list[last_date][:at_close].to_f
      quote[:date] = last_date
    end
    quote
  end

  def self.getDaily(symbol)
    ticker = symbol.upcase
    
    uri_string = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=#{symbol}&apikey=I50S&outputsize=compact"
    uri = URI(uri_string)
    resp =  Net::HTTP.get_response(uri)
    quote_list= {}
    begin
      quote_info = JSON.parse(resp.body)[TIME_SERIES_DAILY]
      
      quote_info.each do |qdate, qinfo|
        quote_list[qdate.to_date] = {
          at_open:  qinfo["1. open"],
          high: qinfo["2. high"],
          low:  qinfo["3. low"],
          at_close:  qinfo["4. close"],
          volume: qinfo["5. volume"]
        }
      end
    rescue
      
    end
    quote_list
  end
  def self.getQuotes(symbols)
    symbols = symbols.collect {|s| s.upcase}
    quotes = self.getBatch(symbols)
    symbols.each do |s|
      if !quotes[s]
        q = self.getLastPrice(s)
        if !quotes.empty? && q
          quotes[s] = { price: q[:price],
                        timestamp: q[:date]
                      }
        end
      end
    end
    quotes
  end
  private
  def self.getBatch(symbols)
    symbols = symbols.collect {|s| s.upcase}
    uri_string = nil
    return_quotes = {}
    if symbols.is_a?(Array)
      uri_string = "https://www.alphavantage.co/query?function=BATCH_STOCK_QUOTES&symbols=#{symbols.join(',')}&apikey=#{ApiKey}"
    else
      uri_string = "https://www.alphavantage.co/query?function=BATCH_STOCK_QUOTES&symbols=#{symbols}&apikey=#{ApiKey}"
    end
    uri = URI(uri_string)
    begin
      resp = Net::HTTP.get_response(uri)
      stock_quotes = JSON.parse(resp.body)["Stock Quotes"]
      stock_quotes.each do |x|
        symbol = x['1. symbol']
        price = x['2. price']
        timestamp = x['4. timestamp']
        return_quotes[symbol] = {price: price.to_f,
                                 timestamp: timestamp
                                }
      end
    rescue
    end
    return_quotes
  end
end




if __FILE__ == $0

  price_importer = ImportAllPrices.new()
  price_importer.import_all


end
