# frozen_string_literal: true

require "spec_helper"

RSpec.describe Capwatch::FundConfig do

  let(:basic)   { fixture_path 'funds/basic.json' }
  let(:dynamic) { fixture_path 'funds/extreme.json' }
  let(:extreme) { fixture_path 'funds/dynamic.json' }

  let(:no_config) { "~/.no_such_config_i_hope" }
  let(:no_subject_config) { subject.new(no_config) }

  subject { described_class }

  context "config file" do

    context "when config file exists" do

      it "#name" do
        expect(subject.new(basic).name).to eq("Basic Fund")
      end

      it "#positions" do
        expect(subject.new(basic).positions).to eq({"MAID"=>25452.47, "GAME"=>22253.51, "NEO"=>3826.53, "FCT"=>525.67875, "SC"=>4152770, "DCR"=>453.22, "BTC"=>8.219, "ETH"=>166.198, "KMD"=>19056.2, "LSK"=>5071.42})
      end

    end

    context "when config does not exist" do

      after do
        FileUtils.rm(no_subject_config.config_path)
      end

      it "creates a random config from fixtures and says it's demo" do
        expect(no_subject_config.name).to eq("Your Demo Fund")
      end

    end

  end

end
