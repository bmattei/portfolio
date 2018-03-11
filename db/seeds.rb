# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
AdminUser.create(email: 'admin@example.com', password: 'password', password_confirmation: 'password')
AdminUser.create(email: 'bob@mwbi.net', password: 'lanDer245', password_confirmation: 'lanDer245')
AdminUser.create(email: 'naturalauram@gmail.com', password: 'natureGirl', password_confirmation: 'natureGirl')

Equity = 0
Bond = 1
Cash = 2
Other = 3
LargeCap = 0
MidCap = 1
SmallCap = 2
Long = 0
Intermediate = 1
Short = 2
High = 0
Medium = 1
Low = 2

require 'byebug'

Category.delete_all
# Add Equity Categories
[LargeCap, SmallCap, MidCap].each do |cap|
  [true, false].each do |domestic|
    [true, false].each do |reit|
      if (domestic)
        Category.create(base_type: Equity,
                        size: cap ,
                        domestic: true,
                        emerging: false,
                        reit: reit)
      else
        [true,false].each do |emerging|
          Category.create(base_type: Equity,
                          size: cap ,
                          domestic: false,
                          emerging: emerging,
                          reit: reit)
        end
      end
    end
  end
end
[Long, Intermediate, Short].each do |duration|
  [High, Medium, Low].each do |quality|
    [true, false].each do |domestic|
      [true, false].each do |gov|
        [true, false].each do |tip|
          Category.create(base_type: Bond,
                          quality: quality ,
                          domestic: domestic,
                          duration: duration,
                          inflation_adjusted: tip,
                          gov: gov)
        end
      end
    end
  end
end
Category.create(base_type: Cash, domestic: true)
Category.create(base_type: Other, domestic: true)
        
                                       
                               

