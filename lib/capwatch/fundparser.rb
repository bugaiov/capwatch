module Capwatch
  class FundParser
    def initialize(filename = '~/.capwatch')
      @capwatch_file = File.expand_path(filename)
    end
    def fund
      JSON.parse(File.open(@capwatch_file).read)
    end
  end
end
