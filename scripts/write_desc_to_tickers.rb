#!/usr/bin/env ruby
# coding: utf-8

$LOAD_PATH << '.'
$LOAD_PATH << './ETL'

require 'net/http'
require 'rubygems'
require 'mysql2'
require 'config/environment.rb'
require 'byebug'

def create_categories

end


if __FILE__ == $0
  info = {:dgs => {description: 'Emerging Markets, SmallCap, Value',
                   idx_name: 'WisdomTree Emerging Markets SmallCap Dividend Index',
                   expenses: 0.63,
                   group: "WisdomTree"},
          :efv => {description: "International Developed, Value",
                   idx_name: "MSCI EAFE Value Index",
                   expenses: 0.4,
                   group: "IShares"},
          :iefa => {description: "International Developed",
                    idx_name: "MSCI EAFE IMI Index",
                    expenses: 0.08,
                    group: "IShares"},
          :schb => {description: "US Stock Market",
                    idx_name: "Dow Jones U.S. Broad Stock Market Index",
                    expenses: 0.03,
                    group: "Schwab"},
          :sche => {description: 'Emerging Markets',
                    idx_name: 'FTSE Emerging Index',
                    expenses: 0.13,
                    group: "Schwab"},
          :scho => {description: "Short Term Treasury",
                    idx_name: "Bloomberg Barclays U.S. 1–3 Year Treasury Bond Index",
                    expenses: 0.06,
                    group: "Schwab",
                    maturity: 2.0,
                    duration: 1.95,
                    quality: 'AAA'},
          :schp => {description: "Intermediate TIPS",
                    idx_name: "Bloomberg Barclays U.S. Treasury Inflation Protected Securities (TIPS) Index",
                    expenses: 0.05,
                    group: "Schwab",
                    maturity: 8.35,
                    duration: 7.66,
                    quality: 'AAA'},
          :schr => {description: "Intermediate Treasuries",
                    idx_name: "Bloomberg Barclays U.S. 3–10 Year Treasury Bond Index",
                    expenses: 0.06,
                    group: "Schwab",
                    maturity: 5.57,
                    duration: 5.17,
                    quality: 'AAA'},
          :scz => {description: "International Developed, SmallCap",
                   idx_name: "MSCI EAFE Small-Cap Index",
                   expenses: 0.4,
                   group: "IShares"},
          :tlt => {description: "Long Term Treasury",
                   idx_name: "ICE U.S. Treasury 20+ Year Bond Index",
                   expenses: 0.15,
                   maturity: 26.02,
                   duration: 17.78,
                   quality: 'AAA',
                   group: "IShares"},
          :vbr => {description: "US SmallCap, Value",
                   idx_name: "CRSP US Large Cap Value Index",
                    group: "Vanguard",
                    expenses: 0.07,
                  },
          :vnq => {description: "US REITS",
                   idx_name: "MSCI US REIT Index",
                   group: "Vanguard",
                   expenses: 0.12,
                  },
          :vtip => {description: "Short Term TIPS",
                    idx_name: "Bloomberg Barclays U.S. Treasury Inflation-Protected Securities (TIPS) 0-5 Year Index, Bond",
                    group: "Vanguard",
                    expenses: 0.07,
                    maturity: 2.6,
                    duration: 2.6,
                    quality: 'AAA'},
          :vtv => {description: "US LargeCap, Value",
                   idx_name: "CRSP US Small Cap Value Index",
                   expenses: 0.06,
                   group: "Vanguard"},
          :vwo => {description: 'Emerging Markets',
                   idx_name: 'FTSE Emerging Markets All Cap China A Inclusion Index',
                   expenses: 0.14,
                   group: "Vanguard"},
          :vempx => {description: "US, MidCap, SmallCap",
                     idx_name: "Spliced Extended Market Index",
                     expenses: 0.06,
                     group: "Vanguard" },
          :vtpsx => {description: "Internation EX US",
                     idx_name: "Spl Total International Stock Index*",
                     expenses: 0.07,
                     group: "Vanguard" },
          :vbmpx => {description: "US Investment Grade Bonds",
                     idx_name: "Bloomberg Barclays U.S. Aggregate Float Adjusted Index",
                     maturity: 8.4,
                     duration: 6.4,
                     expenses: 0.15,
                     group: "Vanguard" },
          
         }
  info.each do |symbol, info|
    ticker = Ticker.where(symbol: symbol).first
    ticker.update(info)
  end
           
end
