class Ticker < ActiveRecord::Base

  has_many :holdings, dependent: :destroy
  has_many :admin_users, through: :holdings
  has_many :prices
  has_many  :category_tickers
  has_many :categories, through: :category_tickers
  has_many :accounts, through: :holdings
  validates :symbol, uniqueness: true
  enum stype: [:mutual_fund, :etf, :stock, :bond]

  DateIdx = 0
  PriceIdx = 1
  CloseKey = '4. close'
  def self.retrieve_prices
    # All tickers that are associated with at least one holding
    # No sense getting prices for tickers no one owns.
    ticker_list = Ticker.all.find_all {|t| t.holdings.count > 0}.collect {|t| t.symbol}
    quote_list = ImportPrices.getQuotes(ticker_list)
    if !quote_list.empty?
      ticker_list.each do |symbol|
        ticker = Ticker.where(symbol: symbol).first
        quote = quote_list[symbol.upcase]
        if quote
          date = quote[:timestamp].to_date
          price = ticker.prices.where(price_date: date).first_or_create(price: quote[:price])
          price.price = quote[:price]
          price.save
        else
          puts "symbol not found #{ticker.symbol}"
        end
      end
    end
  end
  def retrieve_price
    quote_info = ImportPrices.getBatch(self.symbol)
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
  def category
    if !@category
      ct = category_tickers.find {|x| x.split > 0.8 }
      if ct
        @category = ct.category
      end
    end
    @category
  end
  def size
    if category
      category.size
    end
  end
  def foreign
    if category
      !category.domestic
    end
  end
  def base_type
    if category
      category.base_type
    end
  end
  def duration
    if category
      category.duration
    end
  end

  def total
    holdings.inject(0) { |sum, n | sum + n.value } 
  end
  def shares
    holdings.inject(0) { |sum, n | sum + n.shares } 
  end
  def value_percent(sub_cats)
    sum = 0
    self.categories.where(sub_cats).each do |cat|
      self.category_tickers.where(category_id: cat.id).each do |ct|
        sum += ct.split
      end
    end
    sum
  end

  def price_on(dt)
    price = self.prices.where("price_date >= ? and price_date <= ?", dt, dt + 1).order(price_date: :asc).first
    if price
      price.price
    else
      0
    end
  end
  def last_price
    price = self.prices.order(price_date: :asc).last
    if price
      price.price
    else
      0
    end
  end
end
