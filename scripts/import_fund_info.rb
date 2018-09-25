#!/usr/bin/env ruby
# coding: utf-8

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
      config.default_max_wait_time = 25 # seconds
      config.default_driver = :selenium
    end
    @browser = Capybara.current_session
  end

  def go_to_expenses(symbol)
    on_enter
    url_str =  "http://financials.morningstar.com/etfund/operations.html?t=#{symbol}"
    puts url_str
    begin
      @browser.visit(url_str)
    rescue
      @browser.visit(url_str)
    end
    puts @browser.title
    @browser.title =~ /#{symbol.upcase}.*Operations\sOverview/
  end
  def go_to_portfolio_page(symbol)
    on_enter
    url_str =  "http://portfolios.morningstar.com/fund/summary?t=#{symbol}"
    puts url_str
    begin
      @browser.visit(url_str)
    rescue
      @browser.visit(url_str)
    end
    @browser.title =~ /Report.*#{symbol.upcase}/
  end

  def read_expenses(t)
    go_to_fees_and_expense(t)
    
  end
    
  def read_table(t, tbl_info)
    on_enter
    info = {}
    info[:header] = read_table_header(t)
    
    if tbl_info[:prefix_hdr]
      info[:header][:columns].unshift('phdr')
    end
    bodies = do_and_rescue { t.all('tbody') }
    info[:rows] = []
    bodies.each do |body|
      info[:rows] = info[:rows] + read_body(body, tbl_info)
    end
    info
  end

  def read_body(body, tbl_info)
    on_enter
    tr_list = body.all('tr') 
    info = []
    tr_list.each do |tr|
      row = read_row(tr, tbl_info)
      if row
        info << row
      end
    end
    info
  end
  

  def read_row(tr, tbl_info)
    on_enter
    row = nil
    td_list = tr.all('td') 
    td_list_text = td_list.collect {|td| td.text }
    columns = td_list_text.find_all {|x| x.length > 0 }

    if columns.count >= tbl_info[:td_count]
      row = []
      if tbl_info[:row_header]
        col_text = do_and_rescue { tr.find('th').text }
        row << col_text 
      end
      row = row + columns
    end
    row
  end


  def read_table_header(t)
    on_enter
    header_info = nil
    header = t.find('thead') 
    header_info = {}
    th_list = header.all('th')
    th_list_text = th_list.collect {|th| th.text }
    header_info[:columns] = th_list_text.find_all { |t| t.length > 0 }
    header_info[:columns].each do |x|
      x.gsub("\n", "")
      header_info[:columns].delete(x) if x.blank?
    end
    header_info
      
  end
  #
  #(byebug) @browser.has_link?('Bond Style')
  #(byebug) @browser.has_link?('Bond Sector')
  # 'Benchmark Morningstar Category'  => false,
  # 'Stock Portfolio Benchmark Category Avg' =>  false,
  #              'Year Style % Equity' => false,
  #             '% Stocks Benchmark Category Avg Fund Weight Benchmark Weight Category Avg Weight' =>  false,


  
  TableInfo = {
    'Type % Net % Short % Long Bench- mark Cat Avg' => {name: :asset_allocation,
                                                        row_header: true,
                                                        td_count:  5},

    
    'Size % of Portfolio Benchmark Category Avg' =>  {name: :market_cap,
                                                      row_header: true,
                                                      td_count: 3 },

    '% Stocks Benchmark Category Avg' => {name: :market_classification,
                                          row_header: false,
                                          td_count: 3,
                                          prefix_hdr: true},

    'Detail Value' => { name: :bond_data,
                        row_header: true,
                        td_count: 1
                      },
    "% Stocks Benchmark Category Avg Fund Weight Benchmark Weight Category Avg Weight" => {name: :sector_weight,
                                                                                           row_header: true,
                                                                                           td_count: 3,
                                                                                           prefix_hdr: true
                                                                                          },
    "Type % Bonds Benchmark Category Avg Bond Weight Benchmark Weight Category Avg Weight" => {name: :credit_quality,
                                                                                               row_header: true,
                                                                                               td_count: 3},
    "Type % Bonds Benchmark Category Avg Fund Weight Benchmark Weight Category Avg Weight" => {name: :fixed_income_sectors,
                                                                                               row_header: true,
                                                                                               td_count: 3 }
    
  }
  
  
  def get_category
    result =  @browser.find("a.categoryName").text 
  end
  
  def get_benchmark
    result = @browser.find("a.banchmarkName").text 
  end

  def get_expenses
    text = @browser.find("#feesandExpense").find_all('tr')[0].find_all('td')[0].text
    text.gsub(/%/, '').to_f
  end
    
  def extract(symbol)
    on_enter
    symbol_info = {}
    if go_to_expenses(symbol)
      symbol_info[:expenses] = get_expenses
    end
    if go_to_portfolio_page(symbol)
      symbol_info[:category] =    get_category
      symbol_info[:benchmark] =  get_benchmark

      [:stock, :bond].each do | btype |
        if btype == :bond
          if @browser.has_link?('Bond Style')
            @browser.click_on('Bond Style')
            @browser.click_on('Bond Sector')
          else
            break
          end
        end
        
        tables = @browser.all('table')
        tables.each do |t|
          text = do_and_rescue { t.find('thead').text }
          # Morningstar seems somewhat inconsistent with it's headers sometime they contain \n between
          # columns and sometimes spaces.
          text = text.gsub("\n", ' ').strip
          if text
            tbl_info = TableInfo[text]
            if tbl_info
              table_already_read =  symbol_info[tbl_info[:name]]
              if !table_already_read
                symbol_info[tbl_info[:name]] = read_table(t, tbl_info)
              end
            end
          end
        end
      end
    end
    symbol_info
  end

  # def extract(symbol)

  #   scaped_info = nil
  #   if go_to_portfolio_page(symbol)
  #     scraped_info = {}
  #     scraped_info[:category] = get_category
  #     scraped_info[:equity_style_info] = get_bond_stock_style_data
  #     scraped_info[:asset_allocation] = get_asset_allocation_data
  #     scraped_info[:credit_quality] = get_credit_quality
  #     scraped_info[:bond_stats] = get_bond_stats
  #   end
  #   scraped_info
  # end

  def close
    @browser.driver.browser.close
  end

  private
  
  def on_enter
    # puts "ENTER " +  caller[0][/`([^']*)'/, 1]
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
  def initialize(used_only = true)
    @used_only = used_only
    @scraper = MorningstarScraper.new

  end
  def etl_all
    Ticker.all.each do |ticker|
      if !@used_onlu || (@used_only  && ticker.holdings.count >  0)
        etl_ticker(ticker)
      end
    end
  end

  def etl_ticker(ticker)
    info = @scraper.extract(ticker.symbol)
    translate_load(ticker, info)
  end

  
  def normalize_table(t_hash)
    norm_column_keys = t_hash[:header][:columns][1..-1].collect {|x| x.strip.gsub(/[\%\*\s]/,'') }
    norm_row_keys = t_hash[:rows].collect { |r| r[0].strip.gsub(/[\%\*\s]/,'') }
    n_table = {}
    norm_row_keys.each_with_index do |rkey, r_idx|
      if n_table[rkey]
        rkey = rkey + r_idx.to_s
      end
      n_table[rkey] = {}
      norm_column_keys.each_with_index do |ckey, i|
        c_idx = i + 1
        n_table[rkey][ckey] = t_hash[:rows][r_idx][c_idx]
      end
    end
    n_table
  end
  
  def normalize(info)
    n_info = {}
    info.each do |key, value|
      if value.is_a?(Hash)
        n_info[key] = normalize_table(value)
      else
        n_info[key] = value
      end
    end
    n_info
  end

  def load_asset_allocation(ticker, asset_alloc)
    if asset_alloc
      ticker.aa_cash = asset_alloc["Cash"]["Net"].to_f / 100.0
      ticker.aa_us_stock = asset_alloc["USStock"]["Net"].to_f / 100.0
      ticker.aa_non_us_stock = asset_alloc["NonUSStock"]["Net"].to_f / 100.0
            ticker.aa_bond = asset_alloc["Bond"]["Net"].to_f / 100.0
      ticker.aa_other = asset_alloc["Other"]["Net"].to_f / 100.0

      ticker.save
    end
  end

  def load_market_cap(ticker, market_cap)
    if market_cap
      ticker.cap_giant = market_cap["Giant"]["ofPortfolio"].to_f / 100.0
      ticker.cap_large = market_cap["Large"]["ofPortfolio"].to_f / 100.0
      ticker.cap_medium = market_cap["Medium"]["ofPortfolio"].to_f / 100.0
      ticker.cap_small = market_cap["Small"]["ofPortfolio"].to_f / 100.0
      ticker.cap_micro = market_cap["Micro"]["ofPortfolio"].to_f / 100.0
      ticker.save
    end
  end
  def load_sector_weight(ticker, sector_weight)
    if sector_weight
      ticker.ss_basic_material = sector_weight["BasicMaterials"]["Stocks"].to_f / 100.0
      ticker.ss_consumer_cyclical = sector_weight["ConsumerCyclical"]["Stocks"].to_f / 100.0
      ticker.ss_financial_services = sector_weight["FinancialServices"]["Stocks"].to_f / 100.0
      ticker.ss_realestate = sector_weight["RealEstate"]["Stocks"].to_f / 100.0
      ticker.ss_communications_services = sector_weight["CommunicationServices"]["Stocks"].to_f / 100.0
      ticker.ss_energy = sector_weight["Energy"]["Stocks"].to_f / 100.0
      ticker.ss_industrials = sector_weight["Industrials"]["Stocks"].to_f / 100.0
      ticker.ss_technology = sector_weight["Technology"]["Stocks"].to_f / 100.0
      ticker.ss_consumer_defensive = sector_weight["ConsumerDefensive"]["Stocks"].to_f / 100.0
      ticker.ss_healthcare = sector_weight["Healthcare"]["Stocks"].to_f / 100.0
      ticker.ss_utilities = sector_weight["Utilities"]["Stocks"].to_f / 100.0
      ticker.save
    end
  end
  def load_market_classification(ticker, market_classification)
    if market_classification
      ticker.mr_americas = (!market_classification["Americas"]["Stocks"].eql?('—') ?
                              market_classification["Americas"]["Stocks"] :
                              market_classification["Americas"]["Benchmark"]).to_f  / 100.0
      
      ticker.mr_greater_europe = (!market_classification["GreaterEurope"]["Stocks"].eql?('—') ?
                                    market_classification["GreaterEurope"]["Stocks"] :
                                    market_classification["GreaterEurope"]["Benchmark"]).to_f  / 100.0
      
      ticker.mr_greater_asia = (!market_classification["GreaterAsia"]["Stocks"].eql?('—') ?
                                  market_classification["GreaterAsia"]["Stocks"] :
                                  market_classification["GreaterAsia"]["Benchmark"]).to_f  / 100.0
      
      ticker.mc_developed = (!market_classification["DevelopedMarkets"]["Stocks"].eql?('—') ?
                               market_classification["DevelopedMarkets"]["Stocks"] :
                               market_classification["DevelopedMarkets"]["Benchmark"]).to_f  / 100.0
      
      ticker.mc_emerging = (!market_classification["EmergingMarkets"]["Stocks"].eql?('—') ?
                              market_classification["EmergingMarkets"]["Stocks"] :
                              market_classification["EmergingMarkets"]["Benchmark"]).to_f  / 100.0
      ticker.save
    end
  end

  def load_bond_data(ticker, bond_data)
    if bond_data
      ticker.maturity = bond_data["AverageEffectiveMaturity(Years)"]["Value"]
      ticker.duration = bond_data["AverageEffectiveDuration"]["Value"]
    end
  end

  def load_credit_quality(ticker, credit_quality)
    if credit_quality
      ticker.cq_aaa = credit_quality["AAA"]["Bonds"].to_f / 100.0
      ticker.cq_aa = credit_quality["AA"]["Bonds"].to_f / 100.0
      ticker.cq_a = credit_quality["A"]["Bonds"].to_f / 100.0
      ticker.cq_bbb = credit_quality["BBB"]["Bonds"].to_f / 100.0
      ticker.cq_bb = credit_quality["BB"]["Bonds"].to_f / 100.0
      ticker.cq_b = credit_quality["B"]["Bonds"].to_f / 100.0
      ticker.cq_below_b = credit_quality["BelowB"]["Bonds"].to_f / 100.0
      ticker.cq_not_rated = credit_quality["NotRated"]["Bonds"].to_f / 100.0
      ticker.save
    end
  end

  def load_fixed_income_sectors(ticker, fixed_income_sectors)
    if fixed_income_sectors
      ticker.bs_government = fixed_income_sectors["Government"]["Bonds"].to_f / 100.0
      ticker.bs_corporate = fixed_income_sectors["Corporate"]["Bonds"].to_f / 100.0
      ticker.bs_securitized = fixed_income_sectors["Securitized"]["Bonds"].to_f / 100.0
      ticker.bs_municipal = fixed_income_sectors["Municipal"]["Bonds"].to_f / 100.0
      ticker.bs_other = fixed_income_sectors["Other"]["Bonds"].to_f / 100.0
      ticker.bs_cash  = fixed_income_sectors["Cash&Equivalents"]["Bonds"].to_f / 100.0
      if fixed_income_sectors["U.S.TreasuryInflation-Protected"]
        ticker.gov_tips = fixed_income_sectors["U.S.TreasuryInflation-Protected"]["Bonds"].to_f / 100.0
        ticker.gov_nominal = ticker.bs_government - ticker.gov_tips
      else
        ticker.gov_nominal = ticker.bs_government
      end
    end
  end
  def translate_load(ticker, info)
    normalized_info = normalize(info)
    ticker.category = normalized_info[:category]
    ticker.idx_name = normalized_info[:benchmark]
    ticker.expenses = normalized_info[:expense]
    load_asset_allocation(ticker, normalized_info[:asset_allocation])
    load_market_cap(ticker, normalized_info[:market_cap])
    load_sector_weight(ticker, normalized_info[:sector_weight])
    load_market_classification(ticker, normalized_info[:market_classification])
    load_bond_data(ticker, normalized_info[:bond_data])
    load_credit_quality(ticker, normalized_info[:credit_quality])
    load_fixed_income_sectors(ticker, normalized_info[:fixed_income_sectors])
    ticker.save
  end
  def close()
    @scraper.close
  end
end

if __FILE__ == $0


  ems = EtlMorningStar.new
  if ARGV.count > 0
    ARGV.each do |symbol|
      ticker = Ticker.where(symbol: symbol.upcase).first
      if ticker
        ems.etl_ticker(ticker)
      else
        puts "Ticker Not found #{symbol}"
      end
    end
  else
    ems.etl_all
  end
  ems.close()
end







