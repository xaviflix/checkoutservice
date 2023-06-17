require_relative '../utils/exceptions'
require_relative 'base_model'

class Product < BaseModel
  attr_reader :name, :code, :price

  def initialize(name:, code:, price:)
    super
    _check_input_values(name: name, code: code, price: price)
    _check_code_is_unique(code)
    @id = nil
    @name = name
    @code = code # Product code must be unique for each product
    @price = to_money(price)
  end

  private

  def _check_input_values(name:, code:, price:)
    raise InvalidModelValue.new("name", name) if is_empty?(name)
    raise InvalidModelValue.new("code", code) if is_empty?(code)
    raise InvalidModelValue.new("price", price) unless is_decimal?(price)
    raise InvalidModelValue.new("price", price) unless price.positive?
  end

  def _check_code_is_unique(code)
    raise AlreadyExistingProduct.new(code) if @storage.product_code_exist?(code)
  end
end