# frozen_string_literal: true

require 'forwardable'

module Capwatch
  class Fund
    class Config
      extend Forwardable

      attr_reader :parser, :source
      def_delegators :@parser, :name, :currency, :positions, :name=,
                     :currency=, :positions=

      def initialize(source: nil)
        @source = source || dynamic_source
        @parser = Parser.new(source: dynamic_source)
      end

      def dynamic_source
        File.exist?(File.expand_path((Remote::FILE_NAME))) ? Remote.new : Local.new
      end

      def coins
        positions.map do |symbol, quantity|
          Coin.new do |coin|
            coin.fiat_currency = currency
            coin.symbol        = symbol
            coin.quantity      = quantity
          end
        end
      end

      def demo?
        name == Demo::NAME
      end

      class Parser
        attr_accessor :name, :currency, :positions, :raw_data

        def initialize(source:)
          @raw_data = source.get_data
        end

        def parse
          @parse ||= JSON.parse(raw_data)
        end

        def positions
          @positions ||= parse['symbols']
        end

        def name
          @name ||= parse['name']
        end

        def currency
          @currency ||= parse['currency'] || 'USD'
        end

      end

      class Remote
        FILE_NAME = '~/.capwatch.remote'

        def fetch(remote_url)
          open(remote_url).read
        end

        def get_data
          remote_file_url = File.open(File.expand_path(FILE_NAME)).read.strip
          fetch(remote_file_url)
        end

      end

      class Local
        FILE_NAME = '~/.capwatch'

        def get_data
          create_demo_file!
          File.open(File.expand_path(FILE_NAME)).read
        end

        def create_demo_file!
          return if File.exist?(File.expand_path(Local::FILE_NAME))
          Demo.new.create_demo_config
        end

      end

      class Demo
        NAME = 'Your Demo Fund'

        def demo_fund_raw_data
          file_path = File.join(__dir__, '..', '..', 'funds', 'basic.json')
          demo_fund = File.expand_path(file_path)
          File.open(demo_fund).read
        end

        def create_demo_config
          file_name = File.expand_path(Local::FILE_NAME)
          File.open(file_name, 'w') do |file|
            file.write(demo_fund_raw_data.gsub!('Basic Fund', NAME))
          end
        end

      end

    end
  end

end
