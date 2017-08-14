# frozen_string_literal: true

require "json"
require "open-uri"

module Capwatch
  module Providers
    class CoinMarketCap

      attr_accessor :body

      NoCoinInProvider = Class.new(RuntimeError)

      TICKER_URL = "https://api.coinmarketcap.com/v1/ticker/"

      def fetched_json
        response = parse(fetch)
        update_rates(response)
        response
      end

      def fetch
        @body ||= open(TICKER_URL).read
      end

      def parse(response)
        JSON.parse(response)
      end

      def update_rates(response)
        response.each do |coin_json|
          Capwatch::Exchange.rate(
            coin_json['symbol'],
            BigDecimal(coin_json["price_btc"].to_s)
          )
        end
      end

      def update_coin(coin)
        provider_coin = fetched_json.find { |c| c["symbol"] == coin.symbol }
        fail NoCoinInProvider, "No #{coin.symbol} in provider response" if provider_coin.nil?
        coin.name               = provider_coin["name"]
        coin.price_usd          = BigDecimal(provider_coin["price_usd"].to_s)
        coin.price_btc          = BigDecimal(provider_coin["price_btc"].to_s)
        coin.percent_change_1h  = BigDecimal(provider_coin["percent_change_1h"].to_s)
        coin.percent_change_24h = BigDecimal(provider_coin["percent_change_24h"].to_s)
        coin.percent_change_7d  = BigDecimal(provider_coin["percent_change_7d"].to_s)
      end

    end # class CoinMarketCap

  end # module Providers

end
