#!/usr/bin/env ruby
require 'csv'

$LOAD_PATH << '.'
$LOAD_PATH << './ETL'

require 'rubygems'
require 'mysql2'
require 'config/environment.rb'
require 'byebug'
class ImportEtrade

  def initialize(path, user)
    @path = path
    @user = user

  end

  

  SymbolCol = 0
  QuantityCol = 4
  PricePaidCol = 5
  CashCol = 9
  AccountNameCol = 0
  AccountCashCol = 10
  MaxSymbolLength = 5
  def import_data
    if File.file?(@path)
      state = :top
      account = nil
      CSV.foreach(@path) do |row|
        p row
        case state
        when :top
          if row[0].eql?("Account")
            state = :account
          end
        when :account
          account = find_or_add_account(row[AccountNameCol], row[AccountCashCol])
          state = :portfolio_header
        when :portfolio_header
          if row[0].eql?("Symbol")
            state = :portfolio
          end
        when :portfolio
          if row[SymbolCol].eql?("CASH") 
            add_or_update_cash(account, row[CashCol])
            break
          elsif row[SymbolCol].length > MaxSymbolLength
            break
          else
            add_or_update_holding(account, row[SymbolCol], row[QuantityCol], row[PricePaidCol])
          end
        end
      end
    end
  end
  private
  #
  #  It may be possible that amount Cash > Cash purchasing power.  The number we enter
  #  in find_or_update_account is the purchasing cash power.
  #
  def add_or_update_cash(account, cash)
    if account
      account.cash = cash
    end
    account.save
  end

  
  def add_or_update_holding(account, symbol, quantity, price_paid)

    if account
      ticker = Ticker.where(symbol: symbol).first
      if !ticker
        ticker = Ticker.create(symbol: symbol)
      end
      holding = account.holdings.where(ticker_id: ticker.id).first
      if !holding
        holding = account.holdings.create(ticker_id: ticker.id, 
                                          shares: quantity, purchase_price: price_paid )
      else
        holding.shares = quantity
        holding.save
      end
      

    end
  end
  def find_or_add_account(account_name, cash)
    account = @user.accounts.where(name: account_name, brokerage: Account::Etrade).first
    if !account
      account = Account.create(name: account_name, brokerage: Account::Etrade, admin_user_id: @user.id)
    end
    account.cash = cash
    account.save
    account
  end
end

if __FILE__ == $0
  DATA_DIR  = '/Users/robertmattei/Documents/retirement/etrade'
  email = ARGV[0] || 'bob@mwbi.net'
  user = AdminUser.where(email: email).first
  if !user
    puts "Owner not found"
    exit
  end
  
  Dir.entries(DATA_DIR).each do |file|
    path = File.join(DATA_DIR, file)
    if File.file?(path)
      puts path
      importer = ImportEtrade.new(path, user)
      importer.import_data
    end
  end
end
