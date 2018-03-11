class Category < ActiveRecord::Base

  enum base_type: [:equity, :bond, :cash, :other]
  enum size: [:largeCap, :midCap, :smallCap]
  enum duration: [:long, :intermediate, :short]
  enum quality: [:high, :medium, :low]
  enum growth_value: [:growth, :value, :blend]
  enum developed_emerging: [:developed, :emerging, :both]
  has_many :category_tickers
  has_many :tickers, through: :category_tickers

  
end
