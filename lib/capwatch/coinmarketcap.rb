module Capwatch
  class CoinMarketCap
    URL = 'http://api.coinmarketcap.com/v1/ticker/'.freeze
    def self.fetch
      JSON.parse(Net::HTTP.get(URI(URL)))
    end
  end
end
