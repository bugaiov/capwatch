# frozen_string_literal: true

module Capwatch
  class Exchange

    @@rates = {}

    def self.rate_for(symbol)
      raise "No Exchange Rate for #{symbol}" if @@rates[symbol].nil?
      @@rates[symbol]
    end

    def self.rate(symbol, value)
      @@rates[symbol] = value
    end

    def self.rates
      @@rates
    end
  end
end
