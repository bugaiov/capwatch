# frozen_string_literal: true

require 'spec_helper'
require 'ostruct'

RSpec.describe Capwatch::Providers::CoinMarketCap do
  subject { Capwatch::Providers::CoinMarketCap.new(config: config) }

  let(:config) { OpenStruct.new(currency: 'EUR') }
  let(:response) do
    [{ 'symbol' => 'BTC', 'name' => 'Bitcoin', price_btc: 1 }].to_json
  end
  let(:btc) { OpenStruct.new(symbol: 'BTC') }
  let(:unknown_coin) { OpenStruct.new(symbol: 'UNKNOWN_COIN') }
  let(:not_found) { OpenURI::HTTPError.new('404 NOT FOUND', StringIO.new) }

  before do
    allow(subject).to receive(:open).and_return(OpenStruct.new(read: response))
  end

  it 'paginates through the results until the request contains the coin' do
    expect(subject).to receive(:open)
      .with(/&start=0/).ordered
      .and_return(OpenStruct.new(read: [].to_json))
    expect(subject).to receive(:open)
      .with(/&start=100$/).ordered
      .and_return(OpenStruct.new(read: response))

    subject.update_coin(btc)
  end

  it 'paginates through the results until the request gives a 404' do
    expect(subject).to receive(:open)
      .with(/&start=0/).ordered
      .and_return(OpenStruct.new(read: response))
    expect(subject).to receive(:open)
      .with(/&start=100$/).ordered
      .and_raise(not_found)

    expect { subject.update_coin(unknown_coin) }.to raise_exception(
      Capwatch::Providers::CoinMarketCap::NoCoinInProvider,
      'No UNKNOWN_COIN in provider response'
    )
  end

  it 'raise exception if coin cannot be found in any page' do
    allow(subject).to receive(:open).and_raise(not_found)
    expect { subject.update_coin(unknown_coin) }.to raise_exception(
      Capwatch::Providers::CoinMarketCap::NoCoinInProvider,
      'No UNKNOWN_COIN in provider response'
    )
  end

  it 'reraises the OpenURI::HTTPError when it is not a 404' do
    err = OpenURI::HTTPError.new('500', StringIO.new)
    allow(subject).to receive(:open).and_raise(err)
    expect { subject.update_coin(unknown_coin) }.to raise_exception(err)
  end

  it 'fetches the data from v1 ticket API' do
    expected_url = %r{https://api.coinmarketcap.com/v1/ticker/}
    expect(subject).to receive(:open).with(expected_url)
    subject.update_coin(btc)
  end

  it 'fetches using the currency as convert attribute' do
    expect(subject).to receive(:open).with(/\?convert=EUR/)
    subject.update_coin(btc)
  end

  it 'fetches the coin using limit 10' do
    expect(subject).to receive(:open).with(/limit=10/)
    subject.update_coin(btc)
  end
end
