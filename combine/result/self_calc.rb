require 'csv'
require 'time'

TIME_LIMIT = Time.parse('2018/3/1').freeze

trade = CSV.read('all_trade.csv', headers: true)
o = Hash.new { |h, k| h[k] = 0.0 }
trade.each do |c|
  break if TIME_LIMIT <= Time.parse(c['Date'])
  # Date,Dealer,Exchange1,Exchange2,Type,Quantity,Limit,CommissionPaid,Price
  # 2017/07/29,bitFlyer,JPY,ETH,BUY,2.1,23760,,49896
  # 2017/08/19,zaif,BTC,XEM,SELL,750,0.00005805,0.00004354,0.04358104
  ex1, ex2, price, quan = %w[Exchange1 Exchange2 Price Quantity].map { |k| c[k] }
  if c['Type'] == 'BUY'
    o[ex1] -= price.delete(',').to_f
    o[ex2] += quan.delete(',').to_f
  else
    o[ex1] += price.delete(',').to_f
    o[ex2] -= quan.delete(',').to_f
  end
end
deposit = CSV.read('all_deposit_withdrawal.csv', headers: true)
deposit.each do |c|
  # DATE,CURRENCY,UNITS,FEE,FROM,TO
  break if TIME_LIMIT <= Time.parse(c['DATE'])
  next unless c['CURRENCY'] == 'JPY'
  jpy = c['UNITS'].to_f
  o['JPY'] += (c['TO'] == 'BANK')? -jpy : jpy
end
o.each { |cur, amount| puts %(#{cur} : #{amount}) }
