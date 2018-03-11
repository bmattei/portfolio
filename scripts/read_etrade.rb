require 'csv'

dir = ARGV[0] || '/Users/robertmattei/projects/data'
puts "HELLO"
Dir[File.join(dir, '*.csv')].each do |file|
  p file
  CSV.foreach(file) do |row|
    p row
  end
end
