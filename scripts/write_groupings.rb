#!/usr/bin/env ruby

$LOAD_PATH << '.'
$LOAD_PATH << './ETL'

require 'net/http'
require 'rubygems'
require 'mysql2'
require 'config/environment.rb'
require 'byebug'

Grouping.delete_all
Grouping.groups.keys.grep(/^aa/) do |group|
  Grouping.create(super_group: Grouping.super_groups[:asset_allocation],
                   group: Grouping.groups[group],
                   description: group.split('_')[1..-1].join(" ") )
end

Grouping.groups.keys.grep(/^cap/) do |group|
  Grouping.create(super_group: Grouping.super_groups[:market_cap],
                   group: Grouping.groups[group],
                   description: group.split('_')[1..-1].join(" ")
                  )
end

Grouping.groups.keys.grep(/^mc/) do |group|
  Grouping.create(super_group: Grouping.super_groups[:market_classification],
                   group: Grouping.groups[group],
                   description: group.split('_')[1..-1].join(" ")
                  )
end

Grouping.groups.keys.grep(/^quality/) do |group|
  Grouping.create(super_group: Grouping.super_groups[:credit_quality],
                   group: Grouping.groups[group],
                   description: group.split('_')[1..-1].join(" ")
                  )
end

Grouping.groups.keys.grep(/^bs/) do |group|
  Grouping.create(super_group: Grouping.super_groups[:bond_sector],
                   group: Grouping.groups[group],
                   description: group.split('_')[1..-1].join(" ")
                  )
end

Grouping.groups.keys.grep(/^ss/) do |group|
  Grouping.create(super_group: Grouping.super_groups[:stock_sector],
                   group: Grouping.groups[group],
                   description: group.split('_')[1..-1].join(" ")
                  )
end

Grouping.groups.keys.grep(/^mr/) do |group|
  Grouping.create(super_group: Grouping.super_groups[:market_region],
                   group: Grouping.groups[group],
                   description: group.split('_')[1..-1].join(" ")
                  )
end
Grouping.create(super_group: Grouping.super_groups[:tip_non_tip],
                 group: Grouping.groups[:tips],
                 description: 'inflation Protected')
