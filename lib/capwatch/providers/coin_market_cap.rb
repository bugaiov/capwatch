# frozen_string_literal: true

require 'json'
require 'open-uri'

module Capwatch
  module Providers
    class CoinMarketCap
      attr_accessor :body
      attr_reader :config

      NoCoinInProvider = Class.new(RuntimeError)

      TICKER_URL = 'https://api.coinmarketcap.com/v1/ticker/'
      PAGE_LIMIT = 100
      FIRST_PAGE = 0

      def initialize(config:)
        @config = config
      end

      def fetched_json
        body = open(ticker_url).read
        update_rates(parse(body))
      end

      def parse(response)
        JSON.parse(response)
      end

      def update_rates(response)
        response.each do |coin_json|
          Capwatch::Exchange.rate(
            coin_json['symbol'],
            coin_json['price_btc'].to_f
          )
        end
      end

      def update_coin(coin, limit: PAGE_LIMIT, start: FIRST_PAGE)
        begin
          body = open(ticker_url(limit: limit, start: start)).read
          coins = update_rates(parse(body))
        rescue OpenURI::HTTPError => err
          fail unless err.message == '404 NOT FOUND'
          fail_no_coin(coin.symbol)
        end

        provider_coin = coins.find { |c| c['symbol'] == coin.symbol }
        if provider_coin.nil?
          update_coin(coin, limit: limit, start: start += limit)
        else
          coin.attributes = provider_coin
        end
        coin
      end

      private

      def ticker_url(limit: PAGE_LIMIT, start: 0)
        "#{TICKER_URL}?convert=#{config.currency}&limit=#{limit}&start=#{start}"
      end

      def fail_no_coin(symbol)
        fail NoCoinInProvider, "No #{symbol} in provider response"
      end
    end # class CoinMarketCap
  end # module Providers
end
