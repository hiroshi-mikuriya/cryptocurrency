require 'csv'
require 'time'

files = %w[
  bitflyer_trade.csv
  coincheck_trade.csv
  other_exchange_trade.csv
  zaif_trade.csv
]

data = files.each.with_object([]) do |f, o|
  CSV.read(f, headers: true).each { |c| o.push(c) }
end

data.sort_by! { |d| Time.parse(d['Date']) }
p data