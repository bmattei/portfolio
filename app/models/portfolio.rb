class Portfolio < ActiveRecord::Base
  has_many  :tickers, through: :holdings
  has_many  :holdings
end
