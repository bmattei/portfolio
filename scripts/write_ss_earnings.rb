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

  file = ARGV[0]
  if !File.exists?(file)
    puts "File #{file} not found"
    exit
  end
  name = ARGV[1] || "Robert Mattei"
  (first, last) = name.split
  user = User.where(first_name: first, last_name: last).first
  if !user
    puts "User #{name} not found"
    exit
  end
  doc = Nokogiri::XML(File.open(file))
  doc.xpath("//osss:Earnings").each do | x|
    Earning.create(user_id: user.id,
                   year: x.attributes["startYear"].value.to_i,
                   amount: x.children[1].children[0].text.to_i)
  end
  

end
