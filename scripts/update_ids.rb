#!/usr/bin/env ruby
$LOAD_PATH << '.'

require 'rubygems'
# require 'mysql2'
require 'config/environment.rb'

# update all ticker ids > 27 and save new and old id in hash.


# Rails.application.eager_load!
# ApplicationRecord.descendants.each do |m|
#   pp m
#   pp m.maximum(:id)

# end
G_ID_MIN = 4000

byebug
new_id = Ticker.where("id < #{G_ID_MIN}").maximum(:id) + 1
ticker_id_info = {}
byebug
Ticker.where("id > #{G_ID_MIN}").order(id: :asc).each do |t|
  ticker_id_info[t.id] = new_id
  t.id = new_id
  p "#{t.symbol} #{t.id}"
  new_id = new_id + 1
  t.save
end
pp ticker_id_info

# update holdings

Holding.where("ticker_id > #{G_ID_MIN}").each do |h|
  if ticker_id_info[h.ticker_id]
    h.ticker_id = ticker_id_info[h.ticker_id]
    pp h
   h.save
  end
end
# update snapshots

Snapshot.where("ticker_id >  #{G_ID_MIN}").each do |s|
  if ticker_id_info[s.ticker_id]
    s.ticker_id = ticker_id_info[s.ticker_id]
    pp s
   s.save
  end
end
# reset auto update acount in tickers
#increment = Ticker.maximum(:id) + 1
#ActiveRecord::Base.connection.execute('ALTER TABLE tickers AUTO_INCREMENT = #{increment}')

new_u_id = AdminUser.where("id < 4000").maximum(:id) + 1
user_id_info = {}
AdminUser.where("id > #{G_ID_MIN}").order(id: :asc).each do |u|
  user_id_info[u.id] = new_u_id
  u.id = new_u_id
  new_u_id = new_u_id + 1
  pp u
  u.save
end
Account.where("admin_user_id > #{G_ID_MIN}").each do |a|
  if user_id_info[a.admin_user_id]
    a.admin_user_id = user_id_info[a.admin_user_id]
    pp a
  end
  a.save
end


Capture.where("admin_user_id > #{G_ID_MIN}").each do |c|
  if user_id_info[c.admin_user_id]
    c.admin_user_id = user_id_info[c.admin_user_id]
    pp c
  end
  c.save
end

# reset auto update acount in tickers
#increment = AdminUser.maximum(:id) + 1
#ActiveRecord::Base.connection.execute('ALTER TABLE admin_users AUTO_INCREMENT = #{increment}')
