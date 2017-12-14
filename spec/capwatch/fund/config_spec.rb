# frozen_string_literal: true

require 'spec_helper'
require 'fileutils'
require 'pp' # fakefs
require 'fakefs'

RSpec.describe Capwatch::Fund::Config do

  let(:home) { File.expand_path('~') }
  let(:basic)   { 'lib/funds/basic.json' }
  subject { described_class.new }

  before do
    FakeFS.activate!
    FakeFS::FileSystem.clone(basic)
    FileUtils::mkdir_p home
  end

  after do
    FakeFS.deactivate!
  end

  context 'if no config, demo config is created' do

    it '#name' do
      expect(subject.name).to eq('Your Demo Fund')
    end

    it '#currency' do
      expect(subject.currency).to eq('USD')
    end

    it '#positions' do
      expect(subject.positions).to eq(
        'MAID'=>25452.47,
        'GAME'=>22253.51,
        'NEO'=>3826.53,
        'FCT'=>525.67875,
        'SC'=>4152770,
        'DCR'=>453.22,
        'BTC'=>8.219,
        'ETH'=>166.198,
        'KMD'=>19056.2,
        'LSK'=>5071.42
      )
    end
  end

  context 'backwards compatibility' do
    let(:old_file) { "#{__dir__}/../fixtures/no_fiat_currency.json" }

    before(:each) do
      ## Write the fixture out as if it was an existing custom capatch config
      FakeFS::FileSystem.clone(old_file)
      FileUtils.cp(old_file, File.join(home, '.capwatch'))
    end

    it '#currency falls back to USD when not provided' do
      expect(described_class.new.currency).to eq('USD')
    end
  end

end
