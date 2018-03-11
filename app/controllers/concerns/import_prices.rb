
class ImportPrices
  ApiKey = 'I50S'

  # Compact returns only last 10 data points
  
  def initialize(ticker, compact=true, daily=true)
    series = 'TIME_SERIES_DAILY'
    @key = "Time Series (Daily)"
    if !daily
      series = 'TIME_SERIES_WEEKLY'
      @key = "Weekly Time Series"
    end
    @ticker = ticker
    @compact = compact
    if compact
      @uri_str = "https://www.alphavantage.co/query?function=#{series}&symbol=#{ticker.upcase}&apikey=#{ApiKey}&outputsize=compact"
    else
      @uri_str = "https://www.alphavantage.co/query?function=#{series}&symbol=#{ticker.upcase}&apikey=#{ApiKey}"
    end
  end

    
  def import_prices
    uri = URI(@uri_str)
    begin
      resp = Net::HTTP.get_response(uri)
      prices = JSON.parse(resp.body)[@key]
    rescue

    end
  end

end




if __FILE__ == $0

  price_importer = ImportAllPrices.new()
  price_importer.import_all


end
