require 'minitest/autorun'
require 'minitest/reporters'

require_relative '../utils/exceptions'

Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new, Minitest::Reporters::JUnitReporter.new]