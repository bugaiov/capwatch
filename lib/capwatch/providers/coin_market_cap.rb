# frozen_string_literal: true

require "json"
require "open-uri"

module Capwatch
  module Providers
    class CoinMarketCap

      attr_accessor :body
      attr_reader :config

      NoCoinInProvider = Class.new(RuntimeError)

      TICKER_URL = "https://api.coinmarketcap.com/v1/ticker/"

      def initialize(config:)
        @config = config
      end

      def fetched_json
        response = parse(fetch)
        update_rates(response)
      end

      def fetch
        @body ||= open(ticker_url).read
      end

      def parse(response)
        JSON.parse(response)
      end

      def update_rates(response)
        response.each do |coin_json|
          Capwatch::Exchange.rate(
            coin_json['symbol'],
            coin_json["price_btc"].to_f
          )
        end
      end

      def update_coin(coin)
        provider_coin = fetched_json.find { |c| c["symbol"] == coin.symbol }
        fail NoCoinInProvider, "No #{coin.symbol} in provider response" if provider_coin.nil?
        coin.name               = provider_coin["name"]
        coin.price_fiat         = provider_coin[price_attribute].to_f
        coin.price_btc          = provider_coin["price_btc"].to_f
        coin.percent_change_1h  = provider_coin["percent_change_1h"].to_f
        coin.percent_change_24h = provider_coin["percent_change_24h"].to_f
        coin.percent_change_7d  = provider_coin["percent_change_7d"].to_f
      end

      private

      def ticker_url
        "#{TICKER_URL}?convert=#{config.currency}"
      end

      def price_attribute
        "price_#{config.currency.downcase}"
      end

    end # class CoinMarketCap

  end # module Providers

end
