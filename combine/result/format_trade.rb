require 'csv'

BUY = %w[
  通貨ペア(+) Exchange2
  通貨ペア(-) Exchange1
  取引量(+)原価ベース Quantity
  取引量(-)原価ベース Price
].each_slice(2).to_a.freeze
SELL = %w[
  通貨ペア(+) Exchange1
  通貨ペア(-) Exchange2
  取引量(+)原価ベース Price
  取引量(-)原価ベース Quantity
].each_slice(2).to_a.freeze

headers = %w[取引所	日付(JST)	取引項目	通貨ペア(+)	通貨ペア(-)	取引量(+)原価ベース	取引額(+)BTCベース	取引額(+)JPY時価	取引額(+)JPY原価	取引量(-)原価ベース	取引額(-)BTCベース	取引額(-)JPY時価	取引額(-)JPY原価	当日BTC時価	取引手数料	手数料通貨	取引手数料(JPY)]
puts CSV.generate('', headers: headers, write_headers: true) { |out|
  CSV.read('all_trade.csv', 'r', headers: true).each do |c|
    # Date,Dealer,Exchange1,Exchange2,Type,Quantity,Limit,CommissionPaid,Price
    line = headers.each.with_object({}) { |k, o| o[k] = '' }
    # TODO: mod line
    line['取引所'] = c['Dealer']
    line['日付(JST)'] = c['Date']
    buy = c['Type'] == 'BUY'
    line['取引項目'] = buy ? '買い' : '売り'
    (buy ? BUY : SELL).each { |a, b| line[a] = c[b] }
    out << line
  end
}.encode('shift_jis')
