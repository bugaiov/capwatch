require 'optparse'
require 'ostruct'

module Capwatch
  class CLI
    def self.parse(args)
      options = OpenStruct.new
      options.tick = 60 * 5
      opt_parser = OptionParser.new do |opts|
        opts.on('-t', '--tick [Integer]', Integer, 'Tick Interval') do |t|
          options.tick = t
        end
      end
      opt_parser.parse!(args)
      options
    end
  end
end
