require 'colorize'
require 'terminal-table'

require 'capwatch/version'

require 'json'
require 'optparse'
require 'ostruct'
require 'net/http'

module Capwatch
  class Calculator
    def self.fund_hash(fund, coinmarketcap_json)
      table_array = []

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
        table_array << [
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

      footer_row = [
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

      table_array.sort_by! { |a| -a[6].to_f } # DIST (%)

      {}
        .merge(title: title)
        .merge(table_array: table_array)
        .merge(footer_row: footer_row)
    end
  end

  class CLI
    def self.parse(args)
      options = OpenStruct.new
      options.tick = 60 * 5
      opt_parser = OptionParser.new do |opts|
        opts.on('-t', '--tick [Integer]', Integer, 'Tick Interval') do |t|
          options.tick = t
        end
      end
      opt_parser.parse!(args)
      options
    end
  end

  class CoinMarketCap
    def self.fetch
      JSON.parse(Net::HTTP.get(URI('http://api.coinmarketcap.com/v1/ticker/')))
    end
  end

  module ConsoleFormatter
    def fmt(n)
      '$' + n.round(2).to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
    end

    def format_btc(value)
      format('฿%.2f', value)
    end

    def format_eth(value)
      format('Ξ%.2f', value)
    end

    def format_percent(value)
      format('%.2f%', value)
    end

    def condition_color(value)
      percent_value = value.to_f
      if percent_value > 1
        value.green
      elsif percent_value < 0
        value.red
      else
        value.green
      end
    end
  end

  class Console
    extend ConsoleFormatter

    def self.colorize_table(hash)
      hash[:table_array].each do |x|
        x[2] = fmt(x[2])
        x[3] = fmt(x[3])
        x[4] = format_btc(x[4])
        x[5] = format_eth(x[5])
        x[6] = format_percent(x[6])
        x[7] = condition_color(format_percent(x[7]))
        x[8] = condition_color(format_percent(x[8]))
        x[9] = condition_color(format_percent(x[9]))
      end
      hash[:footer_row][3] = fmt(hash[:footer_row][3])
      hash[:footer_row][4] = format_btc(hash[:footer_row][4])
      hash[:footer_row][5] = format_eth(hash[:footer_row][5])
      hash[:footer_row][7] = condition_color(format_percent(hash[:footer_row][7]))
      hash[:footer_row][8] = condition_color(format_percent(hash[:footer_row][8]))
      hash[:footer_row][9] = condition_color(format_percent(hash[:footer_row][9]))
      hash
    end

    def self.draw_table(hash)
      hash = colorize_table(hash)
      table = Terminal::Table.new do |t|
        t.title = hash[:title].upcase
        t.style = {
          border_top: false,
          border_bottom: false,
          border_y: '',
          border_i: '',
          padding_left: 1,
          padding_right: 1
        }
        t.headings = [
          'ASSET',
          'QUANTITY',
          'PRICE',
          'VALUE (USD)',
          'VALUE (BTC)',
          'VALUE (ETH)',
          'DIST (%)',
          '%(1H)',
          '%(24H)',
          '%(7D)'
        ]
        hash[:table_array].each do |x|
          t << x
        end
        t.add_separator
        t.add_row hash[:footer_row]
      end

      table
    end
  end
end
