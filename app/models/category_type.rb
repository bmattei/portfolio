class CategoryType < ActiveRecord::Base
  EquityBondCash = 1
  UsNonUs = 2
  Size = 3
  has_many :categories;
end
