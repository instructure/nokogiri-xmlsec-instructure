# frozen_string_literal: true

require "rspec"
require "xmlsec"

def fixture_path(filename)
  File.join(File.expand_path("fixtures", __dir__), filename)
end

def fixture(path)
  File.read fixture_path(path)
end
