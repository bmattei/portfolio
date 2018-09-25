class AccountType < ApplicationRecord
  Taxable = 1
  TaxDeferred = 2
  TaxFree = 3
  has_many :accounts
end
