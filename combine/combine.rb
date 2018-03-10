require 'csv'
require 'time'

files = %w[
  other_depo_with.csv
  zaif_depo_with.csv
  coincheck_depo_with.csv
  bitflyer_depo_with.csv
]

data = files.each.with_object([]) do |f, o|
  CSV.read(f, headers: true).each { |c| o.push c }
end

data.sort_by! {|a| Time.parse(a['DATE']) }
data.size.times do |i|
  data[i]['DATE'] = Time.parse(data[i]['DATE']).strftime("%Y/%m/%d")
end
puts CSV.generate('', headers: %w[DATE CURRENCY UNITS FEE FROM TO], write_headers: true) { |csv|
  data.each { |d| csv << d }
}
