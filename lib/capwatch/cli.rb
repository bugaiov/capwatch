# frozen_string_literal: true

require "optparse"
require "ostruct"

module Capwatch
  class CLI

    def self.parse(args)
      options = OpenStruct.new
      options.tick = 60
      options.watch = false
      options.anybar = false
      opt_parser = OptionParser.new do |opts|
        opts.on("-t", "--tick [Integer]", Integer, "Tick Interval") do |t|
          options.tick = t
        end
        opts.on("-w", "--[no-]all", "Watching/redrawing the portfolio") do |t|
          options.watch = t
        end
        opts.on("-b", "--[no-]anybar", "Sending information to anybar") do |t|
          options.anybar = t
        end
        opts.on("-a", "--[no-]all", "Show All Cryptocurrencies") do |t|
          options.all = t
        end
        opts.on("-e", "--telegram-token=", String) do |val|
          options.telegram = val
        end
      end
      opt_parser.parse!(args)
      options
    end

  end
end
