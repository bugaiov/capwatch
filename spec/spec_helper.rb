# frozen_string_literal: true

require "coveralls"
Coveralls.wear!

require "bundler/setup"
require "capwatch"
require "webmock/rspec"
require "support/fixtures"

RSpec.configure do |config|

  config.example_status_persistence_file_path = ".rspec_status"
  config.disable_monkey_patching!
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

end
