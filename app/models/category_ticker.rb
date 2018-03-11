class CategoryTicker < ActiveRecord::Base
  belongs_to :ticker
  belongs_to :category
  delegate :symbol, to: :ticker, prefix: false
  delegate :size, :base_type, :duration, :domestic, :emerging, to: :category, prefix: false
end
