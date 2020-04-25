s#!/usr/bin/env ruby
$LOAD_PATH << '.'
require 'selenium-webdriver'
require 'nokogiri'
require 'byebug'
require 'capybara'
require 'config/environment.rb'
SS_PATH = "https://www.ssa.gov/cgi-bin/awiFactors.cgi"

Capybara.register_driver :selenium do |app|  
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.javascript_driver = :chrome
Capybara.configure do |config|  
  config.default_max_wait_time = 10 # seconds
  config.default_driver = :selenium
end
session = Capybara.current_session
driver = session.driver
browser = driver.browser
driver.visit(SS_PATH)
submit_button = session.find_all('.ae-button')[0]
submit_button.click
puts "are we there"

tables = session.find_all('table')
parent_table = tables[1]
factor_table = parent_table.find('table')
rows = factor_table.find_all('tr')
rows[1..-1].each do |r|
  (year, value) = r.text.split
  puts "Years: #{year}"
  factor = SsFactor.find_or_create_by(year: year)
  factor.factor = value
  factor.save
  pp factor
end

driver.quit
