module Capwatch
  class Calculator
    def self.fund_hash(fund, coinmarketcap_json)
      table = []

      title = fund['name']
      symbols = fund['symbols']
      fund_keys = symbols.keys

      price_eth_btc = coinmarketcap_json.find do |x|
        x['symbol'] == 'ETH'
      end['price_usd'].to_f

      filtered_response_json = coinmarketcap_json.select do |x|
        fund_keys.include?(x['symbol'])
      end

      total_value_usd = filtered_response_json.inject(0) do |sum, n|
        sum + symbols[n['symbol']] * n['price_usd'].to_f
      end

      total_value_btc = filtered_response_json.inject(0) do |sum, n|
        sum + symbols[n['symbol']] * n['price_btc'].to_f
      end

      total_value_eth = filtered_response_json.inject(0) do |sum, n|
        sum + symbols[n['symbol']] * n['price_usd'].to_f / price_eth_btc
      end

      distribution_hash = {}

      fund_keys.each do |x|
        x = filtered_response_json.find { |e| e['symbol'] == x }
        symbol = x['symbol']
        asset_name = "#{x['name']} (#{symbol})"
        quant_value = symbols[symbol]
        price = x['price_usd'].to_f
        value_btc = quant_value * x['price_btc'].to_f
        value_eth = quant_value * x['price_usd'].to_f / price_eth_btc
        value_usd = quant_value * x['price_usd'].to_f
        distribution_float = value_usd / total_value_usd
        distribution_hash[symbol] = distribution_float
        distribution = distribution_float * 100
        percent_change_1h = x['percent_change_1h'].to_f || 0
        percent_change_24h = x['percent_change_24h'].to_f || 0
        percent_change_7d = x['percent_change_7d'].to_f || 0
        table << [
          asset_name,
          quant_value,
          price,
          value_usd,
          value_btc,
          value_eth,
          distribution,
          percent_change_1h,
          percent_change_24h,
          percent_change_7d
        ]
      end

      a_1h = filtered_response_json.inject(0) do |sum, n|
        sum + n['percent_change_1h'].to_f * distribution_hash[n['symbol']].to_f
      end

      a_24h = filtered_response_json.inject(0) do |sum, n|
        sum + n['percent_change_24h'].to_f * distribution_hash[n['symbol']].to_f
      end

      a_7d = filtered_response_json.inject(0) do |sum, n|
        sum + n['percent_change_7d'].to_f * distribution_hash[n['symbol']].to_f
      end

      footer = [
        '',
        '',
        '',
        total_value_usd,
        total_value_btc,
        total_value_eth,
        '',
        a_1h,
        a_24h,
        a_7d
      ]

      table.sort_by! { |a| -a[6].to_f } # DIST (%)

      {}
        .merge(title: title)
        .merge(table: table)
        .merge(footer: footer)
    end
  end
end
