#!/usr/bin/env ruby
$LOAD_PATH << '.'
require 'selenium-webdriver'
require 'nokogiri'
require 'capybara'
require 'byebug'
require 'config/environment.rb'

Capybara.register_driver :selenium do |app|  
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end
Capybara.javascript_driver = :chrome
Capybara.configure do |config|  
  config.default_max_wait_time = 10 # seconds
  config.default_driver = :selenium
end
def load_table(table)
  rows = table.find_all('tr')
  rows[1..-1].each do |row|
    columns = row.find_all('td')
    byebug
  end

end
session = Capybara.current_session
driver = session.driver
browser = driver.browser
driver.visit('https://markets.businessinsider.com/funds/mutual-funds/finder')
session.find_field("investmentcompany").select("Fidelity Management & Research Company")
search = session.find_all('.search')[0]
search.click
table = session.find_all('table')[0]
load_table(table)

driver.quit
