# frozen_string_literal: true

module Capwatch
  class FundConfig

    attr_accessor :name, :positions, :config_path

    def initialize(config_path = nil)
      @config_path = config_path || File.expand_path("~/.capwatch")
      demo_config! unless config_exists?
    end

    def positions
      @positions ||= parsed_config["symbols"]
    end

    def name
      @name ||= parsed_config["name"]
    end

    def parsed_config
      parse @config_path
    end

    def coins
      positions.map do |symbol, quantity|
        Coin.new do |coin|
          coin.symbol   = symbol
          coin.quantity = BigDecimal(quantity.to_s)
        end
      end
    end

    def demo?
      name == "Your Demo Fund"
    end

    private

    def open_config(path)
      File.open(path).read
    end

    def parse(path)
      JSON.parse open_config(path)
    end

    def config_exists?
      File.exist? @config_path
    end

    def demo_fund
      demo_fund = File.expand_path(
        File.join(__dir__, "..", "..", "spec", "fixtures", "funds", "basic.json")
      )
      File.open(demo_fund).read
    end

    def demo_config!
      @config_path = File.expand_path(@config_path)
      File.open(@config_path, "w") do |file|
        file.write(demo_fund.gsub!("Basic Fund", "Your Demo Fund"))
      end
    end

  end
end
