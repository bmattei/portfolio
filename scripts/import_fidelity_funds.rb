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
browser = Capybara.current_session
byebug
driver = browser.driver.browser

browser.visit('https://www.fidelity.com/mutual-funds/fidelity-funds/overview')
byebug
driver.quit
