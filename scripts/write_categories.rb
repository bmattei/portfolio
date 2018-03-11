#!/usr/bin/env ruby

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


  category_info = {
    dgs: {
      :EmergingEquityMid => 0.9193,
      :Other => 0.807
    },
    efv: {
      :DevelopedEquityLarge => 0.9903,
      :USEquityLarge => 0.0021,
      :Cash => 0.0056,
      :Other => 0.0019
    },
    iefa: {
      :Cash => 0.0067,
      :USEquityLarge => 0.0110,
      :DevelopedEquityLarge => 0.9815,
      
      :Other => 0.0018
    },
    schb: {
      :Cash => 0.0034,
      :USEquityLarge => 0.9821,
      :DevelopedEquityLarge => 0.0108,
      :Other => 0.0037
    },
    sche: {
      :Cash => 0.0015,
      :EmergingEquityLarge => 0.9632,
      :Other => 0.0352
    },
    scho: {
      :USGovBondShort => 0.9999,
      :Other => 0.0001
    },
    schp: {
      :USGovBondIntermediateTIP => 0.9999,
      :Other => 0.0001
    },
    schr: {
      :USGovBondIntermediate => 0.9999,
      :Other => 0.0001
    },
    scz: {
      :Cash => 0.0050,
      :USEquityMid => 0.0063,
      :DevelopedEquityMid => 0.9852,
      :Other => 0.0044
    },
    tlt: {
      :Cash => 0.0073,
      :USGovBondLong => 0.9927
    },
    vbmpx: {
      :Cash => 0.0233,
      :USCorpBondIntermediate => 0.9765,
      :Other => 0.0002
    },
    vbr: {
      :Cash => 0.0119,
      :USEquitySmall => 0.9791,
      :Other => 0.0089
    },
    vempx: {
      :Cash => 0.0293,
      :USEquitySmall => 0.9499,
      :DevelopedEquitySmall =>  0.0207,
      :Other => 0.0001

    },
    vnq: {
      :Cash => 0.0040,
      :USReitMid => 0.9960
    },
    vtip: {
      :Cash => 0.0048,
      :USGovBondShortTIP => 0.9952
    },
    vtpsx: {
      :Cash => 0.0238,
      :USEquityLarge => 0.0084,
      :DevelopedEquityLarge => 0.9467,
      :Other => 0.021,
      :USGovBondShort =>  0.0001
    },
  vtv: {
    :Cash => 0.0007,
    :USEquityLarge => 0.9923,
    :DevelopedEquityLarge => 0.0069,
    },
  vwo:
    {
      :Cash => 0.0224,
      :EmergingEquityLarge => 0.9309,
      :Other => 0.0468
    }
  }

  category_values = {
    USEquityLarge: {base_type: :equity, size: :largeCap, reit: false, domestic: true},
    USEquityMid: {base_type: :equity, size: :midCap, reit: false, domestic: true},
    USEquitySmall: {base_type: :equity, size: :smallCap, reit: false, domestic: true},

    DevelopedEquityLarge: {base_type: :equity, size: :largeCap, reit: false, domestic: false, emerging: false},
    DevelopedEquityMid: {base_type: :equity, size: :midCap, reit: false, domestic: false, emerging: false},
    DevelopedEquitySmall: {base_type: :equity, size: :smallCap, reit: false, domestic: false, emerging: false },

    EmergingEquityLarge: {base_type: :equity, size: :largeCap, reit: false, domestic: false, emerging: true},
    EmergingEquityMid: {base_type: :equity, size: :midCap, reit: false, domestic: false, emerging: true},
    EmergingEquitySmall: {base_type: :equity, size: :smallCap, reit: false, domestic: false, emerging: true},
    
    USReitLarge: {base_type: :equity, size: :largeCap, reit: true, domestic: true},
    USReitMid: {base_type: :equity, size: :midCap, reit: true, domestic: true},
    USReitSmall: {base_type: :equity, size: :smallCap, reit: true, domestic: true},
    ForeignReutLarge: {base_type: :equity, size: :largeCap, true: false, domestic: false},
    ForeignReitMid: {base_type: :equity, size: :midCap, true: false, domestic: false},
    ForeignReitSmall: {base_type: :equity, size: :smallCap, true: false, domestic: false},
    Other: {base_type: :other},
    Cash: {base_type: :cash},
    USGovBondShort: {base_type: :bond, domestic: true, quality: :high, duration: :short, gov: true, inflation_adjusted: false},
    USGovBondIntermediate: {base_type: :bond, domestic: true, quality: :high, duration: :intermediate, gov: true, inflation_adjusted: false},
    USGovBondLong: {base_type: :bond, domestic: true, quality: :high, duration: :long, gov: true, inflation_adjusted:  false},
    USGovBondShortTIP: {base_type: :bond, domestic: true, quality: :high, duration: :short, gov: true, inflation_adjusted: true},
    USGovBondIntermediateTIP: {base_type: :bond, domestic: true, quality: :high, duration: :intermediate, gov: true, inflation_adjusted: true},
    USGovBondLongTIP: {base_type: :bond, domestic: true, quality: :high, duration: :long, gov: true, inflation_adjusted: true},

    USCorpBondShort: {base_type: :bond, domestic: true, quality: :high, duration: :short, gov: false},
    USCorpBondIntermediate: {base_type: :bond, domestic: true, quality: :high, duration: :intermediate, gov: false},
    USCorpBondLong: {base_type: :bond, domestic: true, quality: :high, duration: :long, gov: false},

    ForeignGovBondShort: {base_type: :bond, domestic: false, quality: :high, duration: :short, gov: true},
    ForeignGovBondIntermediate: {base_type: :bond, domestic: false, quality: :high, duration: :intermediate, gov: true},
    ForeignGovBondLong: {base_type: :bond, domestic: false, quality: :high, duration: :long, gov: true},
    ForeignCorpBondShort: {base_type: :bond, domestic: false, quality: :high, duration: :short, gov: false},
    ForeignCorpBondIntermediate: {base_type: :bond, domestic: false, quality: :high, duration: :intermediate, gov: false},
    ForeignCorpBondLong: {base_type: :bond, domestic: false, quality: :high, duration: :long, gov: false}
    
  }
                     
                     
   
  CategoryTicker.delete_all
  category_info.each do |symbol, ticker_splits|
    ticker = Ticker.where(symbol: symbol).first
    if ticker
      ticker_splits.each do |super_cat, split|
        sub_cats = category_values[super_cat]
        if sub_cats
          cat = Category.where(sub_cats).first
          CategoryTicker.create(category_id: cat.id, ticker_id: ticker.id, split: split);
        else
          puts "not found #{super_cat}"
          exit
        end
      end
    else
      puts "ticker not found #{ticker}"
      exit
    end
  end

end
