$LOAD_PATH << '.'
$LOAD_PATH << './ETL'

require 'rubygems'
require 'mysql2'
require 'config/environment.rb'
require 'byebug'

ticker_file = './test/fixtures/tickers.yml'
File.open(ticker_file, 'w') do |f|
  Ticker.all.each do |t|
    f << "#{t.symbol.upcase}:  \n"
    [:symbol, :maturity, :duaration, :expenses,
     :quality, :idx_name, :group, :description].each do |a|
      if a
        f << "  #{a}: #{t[a]} \n"
      end
    end
    f << "\n"
  end
end
  
