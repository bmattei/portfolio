class Snapshot < ApplicationRecord
  require_dependency 'amounts'
  include Amounts

  belongs_to :ticker
  belongs_to :account
  
  delegate :symbol, :description, :maturity, :duration, :expenses, :quality, :group, to: :ticker, prefix: false, allow_nil: true
  def value
    shares * price.to_f
  end


end
