# frozen_string_literal: true

require "spec_helper"
require "ostruct"

RSpec.describe Capwatch::Providers::CoinMarketCap do

  let(:config) { OpenStruct.new(currency: "EUR") }
  subject { Capwatch::Providers::CoinMarketCap.new(config: config) }

  let(:response) { Hash.new }
  before do
    allow(subject).to receive(:open).and_return(OpenStruct.new(read: response))
  end

  describe "fetch" do
    it "fetches using the currency as convert attribute" do
      expected_url = "https://api.coinmarketcap.com/v1/ticker/?convert=EUR"
      expect(subject).to receive(:open).with(expected_url)
      subject.fetch
    end
  end
end
