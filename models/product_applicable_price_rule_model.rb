require_relative '../utils/exceptions'
require_relative 'base_model'

class ProductApplicablePriceRule < BaseModel
  attr_reader :product_id, :price_rule_id

  def initialize(product_id: ,price_rule_id:)
    super
    _check_input_values(product_id, price_rule_id)
    @id = nil
    @product_id = product_id
    @price_rule_id = price_rule_id
    super
  end

  private

  def _check_input_values(product_id, price_rule_id)
    raise InvalidModelValue.new("product_id", product_id) unless is_int?(product_id)
    raise InvalidModelValue.new("price_rule_id", price_rule_id) unless is_int?(price_rule_id)
    product_applicable_price_rule = @storage.product_applicable_price_rule_by_product_id(product_id)
    raise AlreadyExistingPricesRulesForProduct.new(product_id) unless product_applicable_price_rule.nil?
  end
end

