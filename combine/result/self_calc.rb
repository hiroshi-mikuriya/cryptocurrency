require 'csv'
require 'time'

csv = CSV.read('all_trade.csv', headers: true)
o = Hash.new { |h, k| h[k] = 0.0 }
csv.each do |c|
  # Date,Dealer,Exchange1,Exchange2,Type,Quantity,Limit,CommissionPaid,Price
  # 2017/07/29,bitFlyer,JPY,ETH,BUY,2.1,23760,,49896
  # 2017/08/19,zaif,BTC,XEM,SELL,750,0.00005805,0.00004354,0.04358104
  if c['Type'] == 'BUY'
    o[c['Exchange1']] -= c['Price'].to_f
    o[c['Exchange2']] += c['Quantity'].to_f
  else
    o[c['Exchange1']] += c['Price'].to_f
    o[c['Exchange2']] -= c['Quantity'].to_f
  end
  break if Time.parse('2018/1/1') <= Time.parse(c['Date'])
end
o.each { |cur, amount| puts %(#{cur} : #{amount}) }
