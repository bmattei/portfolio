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

  SsFactor.create(year: 1956, max_earnings: 4200, factor: 13.62)
  SsFactor.create(year: 1957, max_earnings: 4200, factor: 13.21)
  SsFactor.create(year: 1958, max_earnings: 4200, factor: 13.09)
  SsFactor.create(year: 1959, max_earnings: 4800, factor: 12.47)
  SsFactor.create(year: 1960, max_earnings: 4800, factor: 12.00)
  SsFactor.create(year: 1961, max_earnings: 4800, factor: 11.77)
  SsFactor.create(year: 1962, max_earnings: 4800, factor: 11.21)
  SsFactor.create(year: 1963, max_earnings: 4800, factor: 10.94)
  SsFactor.create(year: 1964, max_earnings: 4800, factor: 10.51)
  SsFactor.create(year: 1965, max_earnings: 4800, factor: 10.32)
  SsFactor.create(year: 1966, max_earnings: 6600, factor:  9.74)
  SsFactor.create(year: 1967, max_earnings: 6600, factor:  9.23)
  SsFactor.create(year: 1968, max_earnings: 7800, factor:  8.63)
  SsFactor.create(year: 1969, max_earnings: 7800, factor:  8.16)
  SsFactor.create(year: 1970, max_earnings: 7800, factor:  7.78)
  SsFactor.create(year: 1971, max_earnings: 7800, factor:  7.40)
  SsFactor.create(year: 1972, max_earnings: 9000, factor:  6.74)
  SsFactor.create(year: 1973, max_earnings: 10800, factor: 6.35)
  SsFactor.create(year: 1974, max_earnings: 13200, factor: 5.99)
  SsFactor.create(year: 1975, max_earnings: 14100, factor: 5.57)
  SsFactor.create(year: 1976, max_earnings: 15300, factor: 5.21)
  SsFactor.create(year: 1977, max_earnings: 16500, factor: 4.92)
  SsFactor.create(year: 1978, max_earnings: 17700, factor: 4.56)
  SsFactor.create(year: 1979, max_earnings: 22900, factor: 4.19)
  SsFactor.create(year: 1980, max_earnings: 25900, factor: 3.84)
  SsFactor.create(year: 1981, max_earnings: 29700, factor: 3.49)
  SsFactor.create(year: 1982, max_earnings: 32400, factor: 3.31)
  SsFactor.create(year: 1983, max_earnings: 35700, factor: 3.16)
  SsFactor.create(year: 1984, max_earnings: 37800, factor: 2.98)
  SsFactor.create(year: 1985, max_earnings: 39600, factor: 2.86)
  SsFactor.create(year: 1986, max_earnings: 42000, factor: 2.78)
  SsFactor.create(year: 1987, max_earnings: 43800, factor: 2.61)
  SsFactor.create(year: 1988, max_earnings: 45000, factor: 2.49)
  SsFactor.create(year: 1989, max_earnings: 48000, factor: 2.39)
  SsFactor.create(year: 1990, max_earnings: 51300, factor: 2.29)
  SsFactor.create(year: 1991, max_earnings: 53400, factor: 2.21)
  SsFactor.create(year: 1992, max_earnings: 55500, factor: 2.10)
  SsFactor.create(year: 1993, max_earnings: 57600, factor: 2.09)
  SsFactor.create(year: 1994, max_earnings: 60600, factor: 2.02)
  SsFactor.create(year: 1995, max_earnings: 61200, factor: 1.95)
  SsFactor.create(year: 1996, max_earnings: 62700, factor: 1.86)
  SsFactor.create(year: 1997, max_earnings: 65400, factor: 1.75)
  SsFactor.create(year: 1998, max_earnings: 68400, factor: 1.67)
  SsFactor.create(year: 1999, max_earnings: 72600, factor: 1.58)
  SsFactor.create(year: 2000, max_earnings: 76200, factor: 1.50)
  SsFactor.create(year: 2001, max_earnings: 80400, factor: 1.46)
  SsFactor.create(year: 2002, max_earnings: 84900, factor: 1.45)
  SsFactor.create(year: 2003, max_earnings: 87000, factor: 1.41)
  SsFactor.create(year: 2004, max_earnings: 87900, factor: 1.35)
  SsFactor.create(year: 2005, max_earnings: 90000, factor: 1.30)
  SsFactor.create(year: 2006, max_earnings: 94200, factor: 1.24)
  SsFactor.create(year: 2007, max_earnings: 97500, factor: 1.19)
  SsFactor.create(year: 2008, max_earnings: 102000, factor: 1.16)
  SsFactor.create(year: 2009, max_earnings: 106800, factor: 1.18)
  SsFactor.create(year: 2010, max_earnings: 106800, factor: 1.15)
  SsFactor.create(year: 2011, max_earnings: 106800, factor: 1.12)
  SsFactor.create(year: 2012, max_earnings: 110100, factor: 1.09)
  SsFactor.create(year: 2013, max_earnings: 113700, factor: 1.07)
  SsFactor.create(year: 2014, max_earnings: 117000, factor: 1.03)
  SsFactor.create(year: 2015, max_earnings: 118500, factor: 1.00)
  SsFactor.create(year: 2016, max_earnings: 118500, factor: 1.00)

  

end
