module Capwatch
  class Console
    def self.colorize_table(hash)
      hash[:table].each do |x|
        x[1] = format_usd(x[1])
        x[3] = format_usd(x[3])
        x[4] = format_btc(x[4])
        x[5] = format_eth(x[5])
        x[6] = format_percent(x[6])
        x[7] = condition_color(format_percent(x[7]))
        x[8] = condition_color(format_percent(x[8]))
      end
      hash[:footer][3] = format_usd(hash[:footer][3])
      hash[:footer][4] = format_btc(hash[:footer][4])
      hash[:footer][5] = format_eth(hash[:footer][5])
      hash[:footer][7] = condition_color(format_percent(hash[:footer][7]))
      hash[:footer][8] = condition_color(format_percent(hash[:footer][8]))
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
          'PRICE',
          'QUANTITY',
          'VALUE (USD)',
          'VALUE (BTC)',
          'VALUE (ETH)',
          'DIST %',
          '24H %',
          '7D %'
        ]
        hash[:table].each do |x|
          t << x
        end
        t.add_separator
        t.add_row hash[:footer]
      end

      table
    end

    def self.format_usd(n)
      '$' + n.round(2).to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
    end

    def self.format_btc(value)
      format('฿%.2f', value)
    end

    def self.format_eth(value)
      format('Ξ%.2f', value)
    end

    def self.format_percent(value)
      format('%.2f%', value)
    end

    def self.condition_color(value)
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
end
