# frozen_string_literal: true

module Capwatch
  class Coin
    attr_accessor :name, :symbol, :quantity,
                  :price_fiat, :price_btc,
                  :distribution,
                  :percent_change_1h,
                  :percent_change_24h,
                  :percent_change_7d

    def initialize
      yield self if block_given?
    end

    def value_btc
      price_btc * quantity
    end

    def value_fiat
      price_fiat * quantity
    end

    def value_eth
      price_eth * quantity
    end

    def price_eth
      price_btc / Exchange.rate_for("ETH")
    end

    def serialize
      {
        symbol: symbol,
        name: name,
        quantity: quantity,
        price_fiat: price_fiat,
        price_btc: price_btc,
        distribution: distribution,
        percent_change_1h: percent_change_1h,
        percent_change_24h: percent_change_24h,
        percent_change_7d: percent_change_7d,
        value_btc: value_btc,
        value_fiat: value_fiat,
        value_eth: value_eth,
        price_eth: price_eth,
      }
    end

  end
end
