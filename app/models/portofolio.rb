class Portofolio < ActiveRecord::Base
  has_many: :tickers, through: :holdings
  has_many: :holdings
end
