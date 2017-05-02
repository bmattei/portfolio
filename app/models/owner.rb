class Owner < ActiveRecord::Base
  has_many :accounts
end
