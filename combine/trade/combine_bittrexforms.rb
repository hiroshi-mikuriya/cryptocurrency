require 'csv'
require 'time'

files = %w[
  trade_bittrex.csv
  trade_ccex.csv
  trade_coinexchange.csv
  trade_cryptobridge.csv
  trade_cryptopia.csv
  trade_liqui.csv
]

data = files.each.with_object([]) do |f, o|
  next unless f =~ /trade_(.+).csv/
  ex = $1
  CSV.read(f, headers: true).each do |c|
    c['Dealer'] = ex
    o.push c
  end
end

def parse_time(c, k)
  t = c[k]
  case c['Dealer']
  when 'bittrex', 'cryptopia'
    c[k] =~ %r!(\d+)/(\d+)/(\d+)(.+)! # 10/15/2017 8:44:33 AM
    t = %(#{$2}/#{$3}/#{$1}#{$4})
  when 'liqui'
    c[k] =~ %r!(\d+)/(\d+)/(\d+)(.+)! # 10/15/2017 8:44:33 AM
    t = %(#{$3}/#{$1}/#{$2}#{$4})
  end
  Time.parse(t)
end

data.sort_by! {|a| parse_time(a, 'Closed') }
headers = %w[Date Dealer Exchange1 Exchange2 Type Quantity Limit CommissionPaid Price].freeze
data.size.times do |i|
  date = parse_time(data[i], 'Opened').strftime("%Y/%m/%d")
  data[i]['Date'] = date
  data[i]['Exchange'] =~ /([A-Z]+)-([A-Z]+)/
  data[i]['Exchange1'] = $1
  data[i]['Exchange2'] = $2
  data[i]['Type'] =~ /[A-Z]+_([A-Z]+)/
  data[i]['Type'] = $1
  data[i] = headers.each.with_object({}) { |k, o| o[k] = data[i][k] }
end
puts CSV.generate('', headers: headers, write_headers: true) { |csv|
  data.each { |d| csv << d }
}
