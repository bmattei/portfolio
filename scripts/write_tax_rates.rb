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

  SsFactor.where("year >= 1990").each do |x|
    x.ss_tax_rate = 0.062
    x.medicare_tax_rate = 0.0145
    x.save
  end
  SsFactor.where("year >= 1988 and year <= 1989").each do |x|
    x.ss_tax_rate = 0.0606
    x.medicare_tax_rate = 0.0145
    x.save
  end
  SsFactor.where("year >= 1986 and year <= 1987").each do |x|
    x.ss_tax_rate = 0.057
    x.medicare_tax_rate = 0.0145
    x.save
  end
  SsFactor.where("year >= 1985 and year <= 1985").each do |x|
    x.ss_tax_rate = 0.057
    x.medicare_tax_rate = 0.0135
    x.save
  end
  SsFactor.where("year >= 1984 and year <= 1984").each do |x|
    x.ss_tax_rate = 0.057
    x.medicare_tax_rate = 0.013
    x.save
  end
  SsFactor.where("year >= 1982 and year <= 1983").each do |x|
    x.ss_tax_rate = 0.054
    x.medicare_tax_rate = 0.013
    x.save
  end
  SsFactor.where("year >= 1981 and year <= 1981").each do |x|
    x.ss_tax_rate = 0.0535
    x.medicare_tax_rate = 0.013
    x.save
  end
  SsFactor.where("year >= 1979 and year <= 1980").each do |x|
    x.ss_tax_rate = 0.0508
    x.medicare_tax_rate = 0.0105
    x.save
  end
  SsFactor.where("year >= 1978 and year <= 1978").each do |x|
    x.ss_tax_rate = 0.0505
    x.medicare_tax_rate = 0.01
    x.save
  end
  SsFactor.where("year >= 1974 and year <= 1977").each do |x|
    x.ss_tax_rate = 0.0495
    x.medicare_tax_rate = 0.009
    x.save
  end
  SsFactor.where("year >= 1973 and year <= 1973").each do |x|
    x.ss_tax_rate = 0.0485
    x.medicare_tax_rate = 0.01
    x.save
  end
  SsFactor.where("year >= 1971 and year <= 1972").each do |x|
    x.ss_tax_rate = 0.046
    x.medicare_tax_rate = 0.006
    x.save
  end
  SsFactor.where("year >= 1969 and year <= 1970").each do |x|
    x.ss_tax_rate = 0.042
    x.medicare_tax_rate = 0.006
    x.save
  end
  SsFactor.where("year >= 1968 and year <= 1968").each do |x|
    x.ss_tax_rate = 0.038
    x.medicare_tax_rate = 0.006
    x.save
  end
  SsFactor.where("year >= 1967 and year <= 1967").each do |x|
    x.ss_tax_rate = 0.039
    x.medicare_tax_rate = 0.005
    x.save
  end
  SsFactor.where("year >= 1966 and year <= 1966").each do |x|
    x.ss_tax_rate = 0.0385
    x.medicare_tax_rate = 0.0035
    x.save
  end
  SsFactor.where("year >= 1963 and year <= 1965").each do |x|
    x.ss_tax_rate = 0.03625
    x.medicare_tax_rate = 0.0
    x.save
  end
  SsFactor.where("year >= 1962 and year <= 1962").each do |x|
    x.ss_tax_rate = 0.03125
    x.medicare_tax_rate = 0.0
    x.save
  end
  SsFactor.where("year >= 1960 and year <= 1961").each do |x|
    x.ss_tax_rate = 0.0300
    x.medicare_tax_rate = 0.0
    x.save
  end
  SsFactor.where("year >= 1959 and year <= 1959").each do |x|
    x.ss_tax_rate = 0.025
    x.medicare_tax_rate = 0.0
    x.save
  end
  SsFactor.where("year >= 1957 and year <= 1958").each do |x|
    x.ss_tax_rate = 0.0225
    x.medicare_tax_rate = 0.0
    x.save
  end
  SsFactor.where("year >= 1954 and year <= 1956").each do |x|
    x.ss_tax_rate = 0.02
    x.medicare_tax_rate = 0.0
    x.save
  end
  SsFactor.where("year >= 1950 and year <= 1953").each do |x|
    x.ss_tax_rate = 0.015
    x.medicare_tax_rate = 0.0
    x.save
  end
  SsFactor.where("year >= 1937 and year <= 1949").each do |x|
    x.ss_tax_rate = 0.01
    x.medicare_tax_rate = 0.0
    x.save
  end
    
end
