#!/usr/bin/env ruby
require 'csv'

$LOAD_PATH << '.'
$LOAD_PATH << './ETL'

require 'rubygems'
require 'mysql2'
require 'config/environment.rb'
require 'byebug'
class ImportEtrade

  def initialize(path)
    @path = path
  end

  

  AccountCol = 0
  SymbolCol = 1
  QuantityCol = 3
  PricePaidCol = 11
  TypeCol = 13
  ValueCol = 6


  def import_data
    account_added = false

    if File.file?(@path)
      state = :top
      account = nil
      CSV.foreach(@path) do |row|
        p row
        case state
        when :top
          if row[0].eql?("Account Name/Number")
            state = :portfolio
          end
        when :portfolio
          break if row.count < 3
          if !account
            account = find_or_add_account(row[AccountCol])
            if account
              byebug
              account.holdings.delete_all
            else
              puts "Failed to add account"
              exit
            end
          end
          if row[TypeCol].eql?("Cash")
            add_or_update_cash(account, row[ValueCol].gsub('$',''))
          else
            byebug
            add_or_update_holding(account, row[SymbolCol], row[QuantityCol], row[PricePaidCol].gsub('$',''))
          end
        end
      end
    end
  end

  private
  def add_or_update_cash(account, cash)
    if account
      account.cash = cash
      account.save
    end
  end


  def add_or_update_holding(account, symbol, quantity, price_paid)
    byebug
    if account
      ticker = Ticker.where(symbol: symbol).first
      if !ticker
        ticker = Ticker.create(symbol: symbol)
      end
      byebug
      holding = account.holdings.where(ticker_id: ticker.id).first
      if !holding
        holding = account.holdings.create(ticker_id: ticker.id,
                                 shares: quantity, purchase_price: price_paid )
      end
    end
  end

  private def find_or_add_account(account_name)
    account = Account.where(name: account_name, brokerage: Account::Fidelity).first
    if !account
      account = Account.create(name: account_name, brokerage: Account::Fidelity)
    end
    account
  end


end

if __FILE__ == $0
  DATA_DIR  = '/Users/robertmattei/projects/data/etrade'
  Dir.entires(DATA_DIR).each do |file|
    
    path = File.join(DATA_DIR, file)
    if !File.file?(path)
      puts "File not found: #{path}"
      exit
    end
    importer = ImportEtrade.new(path)
    importer.import_data
  end
end
