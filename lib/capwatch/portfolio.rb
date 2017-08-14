# frozen_string_literal: true

module Capwatch
  class Portfolio
    attr_accessor :funds

    def initialize(funds:)
      @funds = funds
    end

    def total_btc
    end

    def total_usd
    end

    def total_eth
    end

    def change_24h
    end

    def change_27d
    end
  end
end
