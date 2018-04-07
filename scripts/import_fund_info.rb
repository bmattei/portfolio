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
# http://portfolios.morningstar.com/fund/summary?t=vempx

class MorningstarScraper
  MorningStarUrl = 'http://www.morningstar.com'
  @@screen_number = 1
  def initialize
    # Configurations
    Capybara.register_driver :selenium do |app|  
      Capybara::Selenium::Driver.new(app, browser: :chrome)
    end
    Capybara.javascript_driver = :chrome
    Capybara.configure do |config|  
      config.default_max_wait_time = 10 # seconds
      config.default_driver = :selenium
    end
    @browser = Capybara.current_session
    @browser.visit(MorningStarUrl) 
  end

  def go_to_fund_page(name)
    on_enter
    success = try_fund_input(name)
    if !success
      do_and_rescue do
        @browser.find('a.close').click
      end
      success = try_fund_input(name)
    end
  end
  def go_to_portfolio_page()
    on_enter
    success = true
    do_and_rescue do
      success = do_and_rescue { @browser.click_on('Portfolio') }
    end
    success
  end
  def get_style_data
    on_enter
    t = do_and_rescue { browser.find('table#equity_style_tab') }
    if t
      byebug
    else
      byebug
    end
  end
  def get_asset_allocation_data
    t = do_and_rescue { browser.find('table#asset_allocation_tab') }
    if t
      byebug
    else
      byebug
    end
  end
  private

  def on_enter
    puts "ENTER " +  caller[0][/`([^']*)'/, 1]
  end
  
  def log(msg)
    puts caller[0][/`([^']*)'/, 1] + " " + msg
  end

  def try_fund_input(name)
    on_enter
    (1..3).each do |x|
      log("try #{x}")
      success = do_and_rescue do
        inputs = @browser.all('input')
        inputs[0].set("\n#{name}\n")
      end
      puts "success: #{success}"
      break if success
      do_and_rescue { @browser.find('div.search-field').find('a.ui-button').click }
    end
    @browser.title.upcase =~ /#{name.upcase}/
  end

  def do_and_rescue()
    on_enter
    begin
      yield
    rescue Exception => e
      log("RESCUE")
      @browser.save_screenshot "screenshot#{@@screen_number}.png"
      @screen_number = @@screen_number + 1
      puts e.message
      success = false
    end
  end
end

if __FILE__ == $0

  symbol = ARGV[0]
  if symbol
    scraper = MorningstarScraper.new
    if scraper.go_to_fund_page(symbol)
      if scraper.go_to_portfolio_page
        style_info = scraper.get_style_data
        asset_allocation = scraper.get_asset_allocation_data
      end
    end
  end
end      






