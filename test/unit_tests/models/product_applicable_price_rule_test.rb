require_relative '../../test_helper'
require_relative '../../../models/product_applicable_price_rule_model'

class ProductApplicablePriceRuleTest < Minitest::Test
  def setup
    DatabaseStorage.reset
  end

  def test_when_create_product_applicable_price_rule_then_fails_invalid_product_id
    error = assert_raises InvalidModelValue do
      ProductApplicablePriceRule.new(product_id: nil, price_rule_id: nil)
    end
    assert_equal "Input value product_id is not a valid. Details product_id=", error.message
    error = assert_raises InvalidModelValue do
      ProductApplicablePriceRule.new(product_id: "A", price_rule_id: nil)
    end
    assert_equal "Input value product_id is not a valid. Details product_id=A", error.message
  end

  def test_when_create_product_applicable_price_rule_then_fails_invalid_price_rule_id
    error = assert_raises InvalidModelValue do
      ProductApplicablePriceRule.new(product_id: 1, price_rule_id: nil)
    end
    assert_equal "Input value price_rule_id is not a valid. Details price_rule_id=", error.message
    error = assert_raises InvalidModelValue do
      ProductApplicablePriceRule.new(product_id: 1, price_rule_id: "1")
    end
    assert_equal "Input value price_rule_id is not a valid. Details price_rule_id=1", error.message
  end

  def test_when_create_product_applicable_price_rule_then_success
    product_applicable_price_rule = ProductApplicablePriceRule.new(product_id: 11, price_rule_id: 22)
    assert_equal 11, product_applicable_price_rule.product_id
    assert_equal 22, product_applicable_price_rule.price_rule_id
  end

  def test_when_create_product_then_fails_duplicated_code
    product_applicable_price_rule = ProductApplicablePriceRule.new(product_id: 11, price_rule_id: 22)
    product_applicable_price_rule.save
    error = assert_raises AlreadyExistingPricesRulesForProduct do
      ProductApplicablePriceRule.new(product_id: 11, price_rule_id: 33)
    end
    assert_equal "Product has already set prices rules. Product ID=11", error.message
  end
end
