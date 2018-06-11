#!/usr/bin/env ruby
$LOAD_PATH << '.'
require 'selenium-webdriver'
require 'nokogiri'
require 'capybara'
require 'byebug'
require 'config/environment.rb'
SYMBOL_COL = 0
NAME_COL = 1
INDUSTRY_COL = 2
CAP_SYMBOL_COL = 0
CAP_CAP_COL = 6

GIANT_CAP =  200000
LARGE_CAP =   10000
MID_CAP   =    2000


map_to_col = {
  'Industrials' => 'ss_industrials',
  'Health Care' => 'ss_healthcare',
  'Information Technology' => 'ss_technology',
  'Consumer Discretionary' => 'ss_consumer_cyclical',
  'Utilities' => 'ss_utilities',
  'Financials' => 'ss_financial_services',
  'Materials' => 'ss_basic_material',
  'Real Estate' => 'ss_realestate',
  "Consumer Staples" => "ss_consumer_defensive",
  'Energy' => 'ss_energy',
  'Telecommunication Services' => 'ss_communications_services'
}

sp = CSV.read('/Users/robertmattei/projects/portfolio/data/constituents_csv.csv')
sp[1..505].each do |row|
  Ticker.where(symbol: row[SYMBOL_COL]).first_or_create.tap do |t|
    t.name =  row[NAME_COL],
    t.stype =  'stock'
    t.aa_us_stock = 1
    t.mr_americas =  1
    t.mc_developed =  1
    t[map_to_col[row[INDUSTRY_COL]]] = 1                                                           
    t.save
  end
end
sp_cap = CSV.read('/Users/robertmattei/projects/portfolio/data/May-2018-SP-500-Stocks.csv')

sp_cap[3..507].each do |row|
  t = Ticker.where(symbol: row[CAP_SYMBOL_COL]).first
  if t
    market_cap = row[CAP_CAP_COL].gsub(/[$,]/,'').to_f
    case 
    when market_cap > GIANT_CAP
      t.cap_giant = 1
    when market_cap > LARGE_CAP
      t.cap_large = 1
    when market_cap > MID_CAP
      t.cap_medium = 1
    else
      puts "#{t.symbol} cap not set"
    end
    t.save
  end
end        


     
