# frozen_string_literal: true

module Capwatch
  class FundCalculator

    attr_accessor :fund

    def initialize(fund)
      @fund = fund
    end

    def assign_quantity
      fund.coins.each do |coin|
        coin.quantity = fund.positions[coin.symbol]
      end
    end

    def assign_prices
      fund.coins.each do |coin|
        fund.provider.update_coin(coin)
      end
    end

    def distribution
      fund.coins.each do |coin|
        coin.distribution = coin.value_btc / fund.value_btc
      end
    end

  end
end
