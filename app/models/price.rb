class Price < ApplicationRecord
  belongs_to :ticker
  delegate :symbol, :name,  to: :ticker, prefix: false, allow_nil: true
end

