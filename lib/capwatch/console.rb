# frozen_string_literal: true

module Capwatch
  class Console

    attr_accessor :name, :body, :totals

    def initialize(name, body, totals)
      @name   = name
      @body   = format_body(body)
      @totals = format_totals(totals)
    end

    def format_body(body)
      JSON.parse(body).sort_by! { |e| -e["value_btc"].to_f }.map do |coin|
        [
          coin["name"],
          Formatter.format_usd(coin["price_usd"]),
          coin["quantity"],
          Formatter.format_percent(coin["distribution"].to_f * 100),
          Formatter.format_btc(coin["value_btc"]),
          Formatter.format_eth(coin["value_eth"]),
          Formatter.condition_color(Formatter.format_percent(coin["percent_change_24h"])),
          Formatter.condition_color(Formatter.format_percent(coin["percent_change_7d"])),
          Formatter.format_usd(coin["value_usd"])
        ]
      end
    end

    def format_totals(totals)
      [
        "",
        "",
        "",
        "",
        Formatter.format_btc(totals[:value_btc]),
        Formatter.format_eth(totals[:value_eth]),
        Formatter.condition_color(Formatter.format_percent(totals[:percent_change_24h])),
        Formatter.condition_color(Formatter.format_percent(totals[:percent_change_7d])),
        Formatter.format_usd(totals[:value_usd]).bold
      ]
    end

    def draw_table
      table  = Terminal::Table.new do |t|
        t.title = name.upcase
        t.style = {
          border_top: false,
          border_bottom: false,
          border_y: "",
          border_i: "",
          padding_left: 1,
          padding_right: 1
        }
        t.headings = [
          "ASSET",
          "PRICE",
          "QUANTITY",
          "DIST %",
          "BTC",
          "ETH",
          "24H %",
          "7D %",
          "USD"
        ]
        body.each do |x|
          t << x
        end
        t.add_separator
        t.add_row totals
      end

      table
    end


    class Formatter

      class << self

        def format_usd(n)
          "$" + n.to_f.round(2).to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
        end

        def format_btc(value)
          format("฿%.2f", value)
        end

        def format_eth(value)
          format("Ξ%.2f", value)
        end

        def format_percent(value)
          format("%.2f%", value.to_f)
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

    end # class Formatter

  end
end
