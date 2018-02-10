# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Capwatch::Fund do
  let(:config_name) { 'Test Config' }

  let(:config_positions) do
    JSON.parse({ 'BTC': 10, 'ETH': 20 }.to_json)
  end

  let(:config_currency) { 'USD' }

  let(:config) do
    config = Capwatch::Fund::Config.new
    config.name = config_name # override
    config.positions = config_positions
    config.currency = config_currency
    config
  end

  let(:provider) do
    tokens =  [
      {
          'id': 'bitcoin',
          'name': 'Bitcoin',
          'symbol': 'BTC',
          'rank': '1',
          'price_usd': '4082.92',
          'price_btc': '1.0',
          '24h_volume_usd': '3178380000.0',
          'market_cap_usd': '67389717403.0',
          'available_supply': '16505275.0',
          'total_supply': '16505275.0',
          'percent_change_1h': '-0.6',
          'percent_change_24h': '5.76',
          'percent_change_7d': '26.08',
          'last_updated': '1502666052'
      },
      {
          'id': 'ethereum',
          'name': 'Ethereum',
          'symbol': 'ETH',
          'rank': '2',
          'price_usd': '298.824',
          'price_btc': '0.0731086',
          '24h_volume_usd': '1371430000.0',
          'market_cap_usd': '28082931934.0',
          'available_supply': '93978168.0',
          'total_supply': '93978168.0',
          'percent_change_1h': '0.58',
          'percent_change_24h': '-3.69',
          'percent_change_7d': '13.06',
          'last_updated': '1502666050'
      }
    ]

    response = double('HTTP::Response', read: tokens.to_json)
    provider = Capwatch::Providers::CoinMarketCap.new(config: config)
    allow(provider).to receive(:open).and_return(response)
    provider
  end

  subject { described_class.new(config: config, provider: provider) }

  context '#[]' do

    it 'find the right coin by symbol name' do
      expect(subject['ETH'].quantity).to eq 20
    end

    it 'returns nil if exeption if symbol name not found' do
      expect(subject['XXX']).to eq nil
    end

  end

  context 'aggregations' do

    context 'sepetate coins' do

      it '#price_btc' do
        subject
        expect(subject['BTC'].price_btc).to eq 1.0
        expect(subject['ETH'].price_btc).to eq 0.0731086
      end

      it '#price_fiat' do
        subject
        expect(subject['BTC'].price_fiat).to eq 4082.92
        expect(subject['ETH'].price_fiat).to eq 298.824
      end

      it '#price_eth' do
        subject
        expect(subject['BTC'].price_eth).to eq 1 / 0.0731086
        expect(subject['ETH'].price_eth).to eq 1
      end

      it '#value_btc' do
        subject
        expect(subject['BTC'].value_btc).to eq 1.0 * 10
        expect(subject['ETH'].value_btc).to eq 0.0731086 * 20
      end

      it '#value_fiat' do
        expect(subject['BTC'].value_fiat).to eq 4082.92 * 10
        expect(subject['ETH'].value_fiat).to eq 298.824 * 20
      end

      it '#value_eth' do
        expect(subject['BTC'].value_eth).to eq 10 * 1.0 / 0.0731086
        expect(subject['ETH'].value_eth).to eq 1 * 20
      end

      it '#distribution' do
        expect(subject['BTC'].distribution).to eq 1.0 * 10 / (1.0 * 10 + 0.0731086 * 20)
        expect(subject['ETH'].distribution).to eq 0.0731086 * 20 / (1.0 * 10 + 0.0731086 * 20)
      end

      it 'total distribution is 100%' do
        expect((subject['BTC'].distribution + subject['ETH'].distribution)).to eq 1.0
      end

    end

    context 'whole fund' do

      it '#value_btc' do
        expect(subject.value_btc).to eq 1.0 * 10 + 0.0731086 * 20
      end

      it '#value_fiat' do
        expect(subject.value_fiat).to eq 4082.92 * 10 + 298.824 * 20
      end

      it '#value_eth' do
        expect(subject.value_eth).to eq 1 * 20 + 10 / 0.0731086 / 1.0
      end

      it '#percent_change_1h' do
        expect(subject.percent_change_1h).to eq -0.44947329703305805
      end

      it '#percent_change_24h' do
        expect(subject.percent_change_24h).to eq 4.554510726239321
      end

      it '#percent_change_7d' do
        expect(subject.percent_change_7d).to eq 24.419103667263066
      end

    end

    context 'serialize' do
      it '#serialize' do
        expect(JSON.parse(subject.serialize).size).to eq 2
      end
    end

    context 'console' do
      it '#console_table' do
        expect(subject.console_table).to be_kind_of(Terminal::Table)
      end
    end

  end
end
