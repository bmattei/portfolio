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
NAME_COL = 0
SYMBOL_COL = 1
def load_table(table, fund_family)
  rows = table.find_all('tr')
  rows[1..-1].each do |row|
    columns = row.find_all('td')
    name = columns[NAME_COL].text.split(/\;/)[0]
    symbol = columns[SYMBOL_COL].text.upcase
    group = fund_family
    stype = "mutual_fund"
    link = columns[NAME_COL].find_css('a')[0][:href]

    ticker = Ticker.find_or_create_by(symbol: symbol)

    ticker.name = name
    ticker.group = fund_family
    ticker.stype = stype
    ticker.data_link = link
    ticker.save
    pp ticker
  end

end

groups = {"Fidelity" => "Fidelity Management & Research Company",
          "Franklin" => "Franklin Templeton Investment Mgmt",
          "Janus" => "Janus Capital Management LLC",
          "Pimco" => "PIMCO"
         }
fund_family = ARGV[0]
if groups[fund_family]
  family_full_name = groups[fund_family]
  session = Capybara.current_session
  driver = session.driver
  browser = driver.browser
  driver.visit('https://markets.businessinsider.com/funds/mutual-funds/finder')
  session.find_field("investmentcompany").select(family_full_name)
  search = session.find_all('.search')[0]
  search.click
  table = session.find_all('table')[0]
  load_table(table, fund_family)
  has_page = true
  while has_page do
    table = session.find_all('table')[0]
    load_table(table, fund_family)
    has_page = session.has_css?('.pager_next')
    if has_page
      session.find('.pager_next').click
    end
  end
  driver.quit
else
  puts "\nDon't recognize fund family: #{fund_family}\n"
end




