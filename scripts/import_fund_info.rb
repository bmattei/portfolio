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
                                                         
end
    
def copyDataToDB(driver, browser, stype)

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
MorningStarUrl = 'http://www.morningstar.com'
browser.visit(MorningStarUrl)
byebug
copyDataToDB(driver, browser, Ticker.stypes["mutual_fund"])
sleep(1)
browser.click_link('ETFs')
sleep(5)
copyDataToDB(driver, browser, Ticker.stypes['etf'])
driver.quit


