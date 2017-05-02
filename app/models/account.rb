class Account < ActiveRecord::Base
  belongs_to :owner
  belongs_to :account_type
  has_many   :holdings
  
end
