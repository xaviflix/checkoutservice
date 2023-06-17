require 'minitest/autorun'
require "minitest/pride"

require_relative '../utils/exceptions'
require_relative 'storage_mock'

STORAGE = StorageMock.new
