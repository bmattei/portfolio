class Holding < ActiveRecord::Base
  belongs_to :account
  belongs_to :ticker
end
