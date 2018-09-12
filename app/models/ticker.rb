class Ticker < ActiveRecord::Base

  has_many :holdings, dependent: :destroy
  has_many :prices
  has_many :accounts, through: :holdings
  validates :symbol, uniqueness: true
  validates_presence_of :stype
  enum stype: [:mutual_fund, :etf, :stock, :bond]

  DateIdx = 0
  PriceIdx = 1
  CloseKey = '4. close'

  def admin_users
    accounts.collect {|a| a.admin_user }.uniq
  end

  def self.retrieve_prices(ticker_list)
    quote_list = ImportPrices.getQuotes(ticker_list)
    if !quote_list.empty?
      ticker_list.each do |symbol|
        ticker = Ticker.where(symbol: symbol).first
        quote = quote_list[symbol.upcase]
        if quote
          begin
            date = quote[:timestamp].to_date
          rescue
            byebug
          end
          price = ticker.prices.where(price_date: date).first_or_create(price: quote[:price])
          price.price = quote[:price]
          price.save
        else
          puts "symbol not found #{ticker.symbol}"
        end
      end
    end
  end
  def self.retrieve_all_prices
    # All tickers that are associated with at least one holding
    # No sense getting prices for tickers no one owns.
    ticker_list = Ticker.all.find_all {|t| t.holdings.count > 0}.collect {|t| t.symbol}
    self.retrieve_prices(ticker_list)
  end

  def symbol=(s)
    write_attribute(:symbol, s.to_s.upcase)
  end
  def retrieve_price
    quote_info = ImportPrices.getBatch([self.symbol])
    if !quote_info.empty?
      quote = quote_info[self.symbol.upcase]
      date = quote[:timestamp].to_date
      price = self.prices.where(price_date: date).first_or_create(price: quote[:price])
      price.price = quote[:price]
      price.save
    else
      puts "symbol not found #{self.symbol}"
    end
  end
  def total
    holdings.inject(0) { |sum, n | sum + n.value } 
  end
  def shares
    holdings.inject(0) { |sum, n | sum + n.shares } 
  end
  def price_on(dt)
    price = self.prices.where("updated_at >= ? and updated_at <= ?", dt, dt + 1.day).order(price_date: :asc).first
    if price
      price.price
    else
      nil
    end
  end
  def last_price_date
    price = self.prices.order(updated_at: :asc).last
    if price
      price.updated_at
    else
      nil
    end
  end
  def last_price
    price = self.prices.order(updated_at: :asc).last
    if price
      price.price
      else
      nil
    end
  end


  
end
