require 'minitest/autorun'
require 'minitest/reporters'

require_relative '../utils/exceptions'
require_relative 'storage_mock'

STORAGE = StorageMock.new
