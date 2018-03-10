require 'csv'
require 'time'

files = %w[
  other_depo_with.csv
  zaif_depo_with.csv
  coincheck_depo_with
]

data = files.each.with_object([]) do |f, o|
  CSV.read(f, headers: true).each { |c| o.push c }
end

data.sort_by! {|a| Time.parse(a['DATE']) }
puts CSV.generate('', headers: %w[DATE CURRENCY UNITS FEE FROM TO], write_headers: true) { |csv|
  data.each { |d| csv << d }
}
