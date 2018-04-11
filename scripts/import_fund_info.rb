#!/usr/bin/env ruby

$LOAD_PATH << '.'
require 'selenium-webdriver'
require 'nokogiri'
require 'capybara'
require 'byebug'
require 'config/environment.rb'



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
  end

  def go_to_portfolio_page(symbol)
    on_enter
    url_str =  "http://portfolios.morningstar.com/fund/summary?t=#{symbol}"
    puts url_str
    @browser.visit(url_str) 
    @browser.title =~ /Report.*#{symbol.upcase}/
  end
  
  def get_stock_style_data
    on_enter

    info = nil
    t = do_and_rescue { @browser.find('table#equity_style_tab') }
    if t
      info = {}
      capy_rows = t.all('tr')[2..-2]
      capy_rows.each do |x|
        text_row =  x.text
        puts text_row
        columns = /(\D*)\s*([\d,\.]*)/.match(text_row)
        if columns.length > 0
          size_sym = columns[1].strip.gsub(" ", '_').to_sym
          info[size_sym] = columns[2].to_f/100.to_f
        end
      end
    else
      #      
    end
    info
  end
  
  def get_asset_allocation_data
    on_enter
    info = nil
    t = do_and_rescue { @browser.find('table#asset_allocation_tab') }
    if t
      info = {}
      capy_rows = t.all('tr')[2..-2]
      capy_rows.each do |x|
        text_row =  x.text
        if text_row.length > 0
          columns =  /(\D*)(\S*)\s*(\S*)\s*(\S*)/.match(text_row)
          asset_class = columns[1].strip.gsub(" ", '_').to_sym
          info[asset_class] = {net: columns[2].to_f/100.to_f,
                               short: columns[3].to_f/100.to_f,
                               long: columns[4].to_f/100.to_f}
        end
      end
    else
      # 
    end
    return info
  end

  def get_stats
    on_enter
    info = nil
    t = do_and_rescue {@browser.find('div#styleDetails').all('table')[1] }

    if t
      capy_rows = do_and_rescue { t.all('tr')[2..-2] }
      if capy_rows
        info = {}
        capy_rows.each do |capy_row|
          text_row = capy_row.text
          if text_row.length > 2
            data = do_and_rescue {capy_row.all('td')[0].text }
            if data
              field = text_row.split[0...-1].join('_').gsub(/[\*, \(, \)]/, '').to_sym
              info[field] = data
            end
          end
        end
      end
    end
    
    info
  end
  CREDIT_CAPTION = "Credit Quality"
  def get_credit_quality
    on_enter
    info = nil 
    t = do_and_rescue { @browser.find('div#styleDetails').all('table')[2] }
    if t
      caption = do_and_rescue { t.find('caption').text }
      if caption and caption.eql?(CREDIT_CAPTION)
        capy_rows = do_and_rescue { t.all('tr')[2..-2] }
        if capy_rows
          info = {}
          capy_rows.each do |x|
            text_row = x.text
            if text_row.length > 2
              columns = /(\D*)\s*([\d,\.]*)/.match(text_row)
              field = columns[1].strip.gsub(" ", "_").gsub(/\W/,"").to_sym
              info[field] = columns[2].to_f
            end
          end
        end
      end
    end
    info
  end

  def get_category
    result = do_and_rescue {  @browser.find("a.categoryName").text }
  end

  def extract(symbol)

    scaped_info = nil
    if go_to_portfolio_page(symbol)
      scraped_info = {}
      scraped_info[:category] = get_category
      scraped_info[:equity_style_info] = get_stock_style_data
      scraped_info[:asset_allocation] = get_asset_allocation_data
      scraped_info[:credit_quality] = get_credit_quality
      scraped_info[:stats] = get_stats
    end
    scraped_info
  end

  def close
    @browser.driver.browser.close
  end

  private
  
  def on_enter
    puts "ENTER " +  caller[0][/`([^']*)'/, 1]
  end
  
  def log(msg)
    puts caller[0][/`([^']*)'/, 1] + " " + msg
  end
  
  
  
  def do_and_rescue()
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



class EtlMorningStar
  def initialize(new_only = true)
    @new_only = new_only
    @scraper = MorningstarScraper.new

  end
  def etl_all
    Ticker.all.each do |ticker|
      if !@new_only || (@new_only  && ticker.category_tickers.count = 0)
        etl_ticker(ticker)
      end
    end
  end
  def etl_ticker(ticker)
    info = @scraper.extract(ticker.symbol)
    translate_load(ticker, info)
    @scraper.close
  end
  def translate_load(ticker, info)
    pp info
    
  end


end
if __FILE__ == $0

  symbol = ARGV[0]
  ems = EtlMorningStar.new
  if symbol
    ticker = Ticker.where(symbol: symbol.upcase).first
    if ticker
      ems.etl_ticker(ticker)
    end
  else
    ems.etl_all
  end
  
end







