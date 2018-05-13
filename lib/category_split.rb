module CategorySplit
  def self.included(klass)
    klass.extend(ClassMethods)
  end

  module ClassMethods
    def category_value(sub_cat)
      self.all.inject(0) { |sum,n| sum + n.category_value(sub_cat) }
    end
  end
  
  def stock_value
    category_value(base_type: :equity)
  end
  def foreign_stock
    category_value(base_type: :equity, domestic: false)
  end
  def domestic_stock
    category_value(base_type: :equity, domestic: true)
  end
  def domestic_reit
    category_value(base_type: :equity, domestic: true, reit: true)
  end
  def bond_value
    category_value(base_type: :bond)
  end
  def cash_value
    if self.ticker_id
      category_value(base_type: :cash)
    else
      self.cash
    end
  end


  def category_value(sub_cat)
    if self.ticker_id
      if !self.ticker
        byebug
      end
      self.value * self.ticker.value_percent(sub_cat)
    else
      0
    end
  end


end
