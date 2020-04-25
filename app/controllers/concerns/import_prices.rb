
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
        if q
          quotes[s] = { price: q[:price],
                        timestamp: q[:date]
                      }
        end
      end
    end
    quotes
  end
  def self.getQuote(s)
    symbol = s.upcase
    puts symbol
    uri_string = "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=#{symbol}&apikey=#{ApiKey}"
    uri = URI(uri_string)
    return_quote = nil
    begin
      resp = Net::HTTP.get_response(uri)
      quote_data = JSON.parse(resp.body)["Global Quote"]
      if quote_data["05. price"]
        return_quote = {}
        return_quote[:price] = quote_data["05. price"].to_f
        return_quote[:timestamp] = quote_data["07. latest trading day"]
      end
      
    rescue StandardError => e
      puts "UHOH #{e.message}"
      byebug
    end
    sleep 12
    return_quote
  end

  
  private

  def self.getBatch(symbols)

    uri_string = nil
    return_quotes = {}
    # BATCH_STOCK_QUOTES IS NO LONGER WORKING
=begin
    if symbols.is_a?(Array)
      symbols = symbols.collect {|s| s.upcase}    
      uri_string = "https://www.alphavantage.co/query?function=BATCH_STOCK_QUOTES&symbols=#{symbols.join(',')}&apikey=#{ApiKey}"
    else
      symbols = symbols.upcase
      uri_string = "https://www.alphavantage.co/query?function=BATCH_STOCK_QUOTES&symbols=#{symbols}&apikey=#{ApiKey}"
    end
    byebug
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
=end
    if !symbols.is_a?(Array)
      symbols = [symbols.to_s.upcase]
    else
      symbols =  symbols.collect {|s| s.to_s.upcase}    
    end
    symbols.each do |s|
      quote_data = self.getQuote(s)
      if quote_data and !quote_data.empty?
        return_quotes[s] = quote_data
      end
    end
    return_quotes
  end
end




if __FILE__ == $0

  price_importer = ImportAllPrices.new()
  price_importer.import_all


end
