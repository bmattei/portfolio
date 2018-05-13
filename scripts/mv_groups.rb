#!/usr/bin/env ruby

$LOAD_PATH << '.'
require 'selenium-webdriver'
require 'nokogiri'
require 'capybara'
require 'byebug'
require 'config/environment.rb'

GroupingsTicker.all.each do |gt|
  if Ticker.first.attributes.include?(gt.group)
    t = gt.ticker
    t[gt.group] = gt.split
    t.save
  elsif gt.group == "tips"
    t = gt.ticker
    t.gov_tips = gt.split
    t.save
  end
  
end


Ticker.all.each do |t|
  if t.bs_government && t.gov_tips
    t.gov_nominal = t.bs_government - t.gov_tips
  end
end

