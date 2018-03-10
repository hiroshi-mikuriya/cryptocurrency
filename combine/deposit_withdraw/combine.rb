require 'csv'
require 'time'

data = Dir.glob('*.csv').to_a.each.with_object([]) do |file, o|
  csv = CSV.read(file, headers: true)
  csv.each { |d| o.push(d) }
end

data.size.times do |i|
  m, d, y = data[i]['DATE'].split('/')
  data[i]['DATE'] = %(#{y}/#{m}/#{d})
end
data.sort_by! { |a| a['DATE'] }

puts CSV.generate('', headers: %w[DATE CURRENCY UNITS FROM TO], write_headers: true) { |csv|
  data.each { |d| csv << d }
}
