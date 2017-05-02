class Ticker < ActiveRecord::Base

  has_many :holdings
  has_many :prices
  #has_many :attribute_tickers

  has_many :accounts, through: :holdings
  #has_many :attributes, through: :attribute_tickers

end
