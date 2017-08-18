# frozen_string_literal: true

require "spec_helper"

RSpec.describe Capwatch::Coin do
  let(:btc_coin) {
    Capwatch::Coin.new do |coin|
      coin.name               = 'Bitcoin'
      coin.symbol             = 'BTC'
      coin.price_usd          = 5_000
      coin.price_btc          = 1
      coin.percent_change_1h  = 23
      coin.percent_change_24h = 25
      coin.percent_change_7d  = 10
    end
  }

  let(:eth_coin) {
    Capwatch::Coin.new do |coin|
      coin.name               = 'Ether'
      coin.symbol             = 'ETH'
      coin.price_usd          = 5_000
      coin.price_btc          = 0.1
      coin.percent_change_1h  = 70
      coin.percent_change_24h = 25
      coin.percent_change_7d  = 10
    end
  }

  before do
    Capwatch::Exchange.rate('ETH', 0.1)
    Capwatch::Exchange.rate('BTC', 1)
  end

  context "values" do

    it '#btc' do
      expect(eth_coin.price_btc).to eq 0.1
    end

    it '#usd' do
      expect(eth_coin.price_usd).to eq 5_000
    end

  end
end
