require 'csv'
require 'time'

data = Dir.glob('*/**/*.csv').to_a.each.with_object([]) do |file, o|
  next unless file =~ /trade_bittrexform/
  # next unless file =~ /deposit_bittrexform/
  # next unless file =~ /withdrawal_bittrexform/
  csv = CSV.read(file, headers: true)
  csv.each { |d| o.push(d) }
end

data.sort_by! { |a| b = a['Opened'].split('/'); b[2] + b[0] + b[1] }

puts data