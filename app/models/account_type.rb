class AccountType < ActiveRecord::Base
  Taxable = 1
  TaxDefered = 2
  TaxFree = 3
  has_many :accounts
end
