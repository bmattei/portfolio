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
