class Ticker < ActiveRecord::Base

  has_many :holdings, dependent: :destroy
  has_many :prices
  has_many :categories, through: :category_tickers
  has_many  :category_tickers
  
  #has_many :attribute_tickers

  has_many :accounts, through: :holdings
  #has_many :attributes, through: :attribute_tickers
  DateIdx = 0
  PriceIdx = 1
  CloseKey = '4. close'
  def self.retrieve_prices
    Ticker.all.each do |ticker|
      ticker.retrieve_prices
    end
  end
  def retrieve_prices
      importer = ImportPrices.new(self.symbol)

      prices = importer.import_prices
      if prices
        prices.each do |x|
          date = x[DateIdx].to_date
          closing_price = x[PriceIdx][CloseKey]
          price = self.prices.where(price_date: date).first_or_create(price: closing_price)
          # Incase record exists update it with the latest price for that date
          price.price = closing_price
          price.save
        end
      else
        puts "symbol not found #{self.symbol}"
      end
  end
  def category
    if !@category
      puts self.symbol
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
