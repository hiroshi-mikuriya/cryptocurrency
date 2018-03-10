require 'csv'
require 'time'

headers = %w[DATE CURRENCY UNITS FEE FROM TO]
dst = []

Dir.glob('*/**.csv') do |f|
  csv = CSV.read(f, 'r', headers: true)
  case f
  when /\/(.+)_withdraw/
    cur = $1.upcase
    csv.each do |c|
      date, amount, fee, tx = %w[日時 金額 手数料 TX].map { |k| c[k] }
      dst.push [date.gsub('-', '/'), cur, amount, fee, 'zaif', '']
    end
  when /\/(.+)_deposit/
    cur = $1.upcase
    csv.each do |c|
      date, amount, tx = %w[日時 金額 TX].map { |k| c[k] }
      dst.push [date.gsub('-', '/'), cur, amount, '', '', 'zaif']
    end
  end
end

dst.sort_by! {|d| Time.parse d[0]}
headers = %w[DATE CURRENCY UNITS FEE FROM TO]
puts CSV.generate('', headers: headers, write_headers: true) { |csv| dst.each { |d| csv << d } }
