# frozen_string_literal: true

require "spec_helper"
require "fileutils"
require "pp" # fakefs
require "fakefs"

RSpec.describe Capwatch::Fund::Config do

  let(:basic)   { "lib/funds/basic.json" }
  subject { described_class.new }

  before do
    FakeFS.activate!
    FakeFS::FileSystem.clone(basic)
    FileUtils::mkdir_p File.expand_path("~")
  end

  after do
    FakeFS.deactivate!
  end

  context "if no config, demo config is created" do
    it "#name" do
      expect(subject.name).to eq("Your Demo Fund")
    end

    it "#positions" do
      expect(subject.positions).to eq(
        "MAID"=>25452.47,
        "GAME"=>22253.51,
        "NEO"=>3826.53,
        "FCT"=>525.67875,
        "SC"=>4152770,
        "DCR"=>453.22,
        "BTC"=>8.219,
        "ETH"=>166.198,
        "KMD"=>19056.2,
        "LSK"=>5071.42
      )
    end
  end

end
