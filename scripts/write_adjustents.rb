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

  SsAdjustment.create(start_year: 1943, end_year: 1954 , full_retirement_months: (66 * 12))
  SsAdjustment.create(start_year: 1955, end_year: 1955 , full_retirement_months: (66 * 12) + 2)
  SsAdjustment.create(start_year: 1956, end_year: 1956 , full_retirement_months: (66 * 12) + 4)
  SsAdjustment.create(start_year: 1957, end_year: 1957 , full_retirement_months: (66 * 12) + 6)
  SsAdjustment.create(start_year: 1958, end_year: 1958 , full_retirement_months: (66 * 12) + 8)
  SsAdjustment.create(start_year: 1959, end_year: 1959 , full_retirement_months: (66 * 12) + 10)
  SsAdjustment.create(start_year: 1960, end_year: 2010 , full_retirement_months: (67 * 12))

end
