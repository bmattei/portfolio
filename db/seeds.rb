# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


require 'byebug'

# USER_ONE

byebug 
user_one = AdminUser.find_or_create_by(email: 'example_one@mwbi.net') do |user|
  user.password = 'password'
end

one_taxable = Account.find_or_create_by(name: 'AccountTaxable',
               brokerage: 'Fidelity',
               account_type_id: AccountType::Taxable,
               admin_user_id: user_one.id,
               cash: 10500)

one_roth = Account.find_or_create_by(name: 'RothIra',
               brokerage: 'Fidelity',
               account_type_id: AccountType::TaxFree,
               admin_user_id: user_one.id,
               cash: 650)

Holding.find_or_create_by(account_id: one_roth.id,
               ticker_id: Ticker.where(symbol: 'IBM').first.id,
               shares: 100,
               purchase_date: Date.strptime("09/01/2009", "%m/%d/%Y"),
               purchase_price: 116.69)

Holding.find_or_create_by(account_id: one_roth.id,
               ticker_id: Ticker.where(symbol: 'F').first.id,
               shares: 1200,
               purchase_date: Date.strptime("01/10/2017", "%m/%d/%Y"),
               purchase_price: 11.71)

Holding.find_or_create_by(account_id: one_roth.id,
               ticker_id: Ticker.where(symbol: 'VNQ').first.id,
               shares: 150,
               purchase_date: Date.strptime("02/14/2017", "%m/%d/%Y"),
               purchase_price: 83.40)


one_ira = Account.find_or_create_by(name: 'Ira',
               brokerage: 'Fidelity',
               account_type_id: AccountType::TaxDeferred,
               admin_user_id: user_one.id,
               cash: 20900)

Holding.find_or_create_by(account_id: one_ira.id,
               ticker_id: Ticker.where(symbol: 'AAPL').first.id,
               shares: 1000,
               purchase_date: Date.strptime("09/01/2015", "%m/%d/%Y"),
               purchase_price: 107.72)

Holding.find_or_create_by(account_id: one_ira.id,
               ticker_id: Ticker.where(symbol: 'DGS').first.id,
               shares: 900,
               purchase_date: Date.strptime("05/10/2016", "%m/%d/%Y"),
               purchase_price: 45.28)

Holding.find_or_create_by(account_id: one_ira.id,
               ticker_id: Ticker.where(symbol: 'SCHB').first.id,
               shares: 5000,
               purchase_date: Date.strptime("02/17/2015", "%m/%d/%Y"),
               purchase_price: 50.85)


# USER_TWO

user_two = AdminUser.find_or_create_by(email: 'example_two@mwbi.net') do |user|
  user.password = 'password'
end
two_taxable = Account.find_or_create_by(name: 'AccountTaxable',
               brokerage: 'Vangaurd',
               account_type_id: AccountType::Taxable,
               admin_user_id: user_one.id,
               cash: 1500)

two_401k = Account.find_or_create_by(name: '401k',
               brokerage: 'Vanguard',
               account_type_id: AccountType::TaxDeferred,
               admin_user_id: user_two.id,
               cash: 2900)

Holding.find_or_create_by(account_id: two_401k.id,
               ticker_id: Ticker.where(symbol: 'ABBV').first.id,
               shares: 3400,
               purchase_date: Date.strptime("02/11/2014", "%m/%d/%Y"),
               purchase_price: 49.66)

Holding.find_or_create_by(account_id: two_401k.id,
               ticker_id: Ticker.where(symbol: 'C').first.id,
               shares: 100,
               purchase_date: Date.strptime("10/10/2006", "%m/%d/%Y"),
               purchase_price: 508.10)

Holding.find_or_create_by(account_id: two_401k.id,
               ticker_id: Ticker.where(symbol: 'GE').first.id,
               shares: 500,
               purchase_date: Date.strptime("8/8/2016", "%m/%d/%Y"),
               purchase_price: 31.27)

user_three = AdminUser.find_or_create_by(email: 'example_three@mwbi.net') do |user|
  user.password = 'password'
end


three_401k = Account.find_or_create_by(name: '401k',
               brokerage: 'Vanguard',
               account_type_id: AccountType::TaxDeferred,
               admin_user_id: user_three.id,
               cash: 29000)

Holding.find_or_create_by(account_id: three_401k.id,
               ticker_id: Ticker.where(symbol: 'TLT').first.id,
               shares: 2000,
               purchase_date: Date.strptime("02/11/2015", "%m/%d/%Y"),
               purchase_price: 129.95)

Holding.find_or_create_by(account_id: three_401k.id,
               ticker_id: Ticker.where(symbol: 'VTWSX').first.id,
               shares: 2000,
               purchase_date: Date.strptime("02/11/2015", "%m/%d/%Y"),
               purchase_price: 24.79)


user_four = AdminUser.find_or_create_by(email: 'example_four@mwbi.net') do |user|
  user.password = 'password'
end

four_401k = Account.find_or_create_by(name: '401k',
               brokerage: 'Vanguard',
               account_type_id: AccountType::TaxDeferred,
               admin_user_id: user_four.id,
               cash: 2000)

Holding.find_or_create_by(account_id: four_401k.id,
               ticker_id: Ticker.where(symbol: 'VPU').first.id,
               shares: 200)

Holding.find_or_create_by(account_id: four_401k.id,
               ticker_id: Ticker.where(symbol: 'VOX').first.id,
               shares: 200)

Holding.find_or_create_by(account_id: four_401k.id,
               ticker_id: Ticker.where(symbol: 'VTIP').first.id,
               shares: 1400)

Holding.find_or_create_by(account_id: four_401k.id,
               ticker_id: Ticker.where(symbol: 'VFH').first.id,
               shares: 300)







               

