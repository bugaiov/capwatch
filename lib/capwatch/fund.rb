# frozen_string_literal: true

module Capwatch
  class Fund
    attr_accessor :provider, :config, :coins, :positions

    def initialize(provider:, config:)
      @provider = provider
      @config = config
      @positions = config.positions
      @coins = config.coins
      build
    end

    def [](symbol)
      coins.find { |coin| coin.symbol == symbol }
    end

    def value_btc
      coins.map(&:value_btc).sum
    end

    def value_usd
      coins.map(&:value_usd).sum
    end

    def value_eth
      coins.map(&:value_eth).sum
    end

    def percent_change_1h
      coins.map { |coin| coin.percent_change_1h * coin.distribution }.sum
    end

    def percent_change_24h
      coins.map { |coin| coin.percent_change_24h * coin.distribution }.sum
    end

    def percent_change_7d
      coins.map { |coin| coin.percent_change_7d * coin.distribution }.sum
    end

    def build
      calculator.assign_quantity
      calculator.assign_prices
      calculator.distribution
    end

    def calculator
      @calculator ||= FundCalculator.new(self)
    end

    def serialize
      coins.map { |coin| coin.serialize }.to_json
    end

    def fund_totals
      {
        value_usd: value_usd,
        value_btc: value_btc,
        value_eth: value_eth,
        percent_change_24h: percent_change_24h,
        percent_change_7d: percent_change_7d
      }
    end

    def console_table
      Console.new(name = config.name, body = serialize, totals = fund_totals).draw_table
    end
  end
end
