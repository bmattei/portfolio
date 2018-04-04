#!/usr/bin/env ruby
$LOAD_PATH << '.'
require 'selenium-webdriver'
require 'nokogiri'
require 'capybara'
require 'byebug'
require 'config/environment.rb'
NAME_COL = 1
SYMBOL_COL = 2
ASSET_CLASS_COL = 3
EXPENSE_COL = 4
PRICE_COL = 5

def translateAndLoad(columns, browser, stype)
  name = columns[NAME_COL].text.strip
  link = columns[NAME_COL].css('a')[0].values[0]
  byebug
  symbol = columns[SYMBOL_COL].text.strip
  description = columns[ASSET_CLASS_COL].text.strip
  expenses = columns[EXPENSE_COL].text.to_d

  ticker = Ticker.find_or_create_by(symbol: symbol)
  
  ticker.name = name
  ticker.description = description
  ticker.expenses = expenses
  ticker.group = 'Vanguard'
  ticker.stype = stype
  ticker.data_link = link
  ticker.save

  
  puts "#{name} #{symbol} #{description}"
                                                         
end
    
def copyDataToDB(driver, browser, stype)
  doc = Nokogiri::HTML(driver.page_source)
  noko_productList = doc.css('.productEntry')
  noko_productList.each do |noko_product|
    noko_columns = noko_product.css("td")
    translateAndLoad(noko_columns,browser,  stype)
  end
end
# Configurations
Capybara.register_driver :selenium do |app|  
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end
Capybara.javascript_driver = :chrome
Capybara.configure do |config|  
  config.default_max_wait_time = 10 # seconds
  config.default_driver = :selenium
end
# Visit
browser = Capybara.current_session
driver = browser.driver.browser

browser.visit('https://investor.vanguard.com/mutual-funds/list#/mutual-funds/asset-class/month-end-returns')
copyDataToDB(driver, browser, Ticker.stypes["mutual_fund"])
sleep(1)
browser.click_link('ETFs')
sleep(5)
copyDataToDB(driver, browser, Ticker.stypes['etf'])
driver.quit


