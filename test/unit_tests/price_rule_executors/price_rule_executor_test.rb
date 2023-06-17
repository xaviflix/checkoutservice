require_relative '../../test_helper'
require_relative '../../../models/price_rule_model'
require_relative '../../../lib/price_rule_executor/price_rule_executor'

class PriceRuleExecutorTest < Minitest::Test
  def test_when_amount_with_discounts_then_fails_unsupported_price_rule_type
    basic_config = {price: 10.0, num_of_items: 1, price_rule: OpenStruct.new(type: "UNKNOWN_PRICE_RULE_TYPE")}
    error = assert_raises UnsupportedPriceRuleType do
      PriceRuleExecutor.amount_with_discounts(**basic_config)
    end
    assert_equal "Unsupported price rule configuration. Details: Unsupported price rule type UNKNOWN_PRICE_RULE_TYPE", error.message
  end

  def test_when_amount_with_discounts_then_success_free_item_price_rule
    price_rule = PriceRule.new(type: "FREE_ITEMS_RULE", config: {paid_items_count: 2, free_items_count: 1})
    basic_config = {price: 10.0, num_of_items: 1, price_rule: price_rule}
    assert_equal 10.0, PriceRuleExecutor.amount_with_discounts(**basic_config)
    assert_equal 20.0, PriceRuleExecutor.amount_with_discounts(**basic_config.merge(num_of_items: 2))
    assert_equal 20.0, PriceRuleExecutor.amount_with_discounts(**basic_config.merge(num_of_items: 3))
    assert_equal 30.0, PriceRuleExecutor.amount_with_discounts(**basic_config.merge(num_of_items: 4))
    assert_equal 40.0, PriceRuleExecutor.amount_with_discounts(**basic_config.merge(num_of_items: 5))
    assert_equal 40.0, PriceRuleExecutor.amount_with_discounts(**basic_config.merge(num_of_items: 6))
    assert_equal 50.0, PriceRuleExecutor.amount_with_discounts(**basic_config.merge(num_of_items: 7))
  end

  def test_when_amount_with_discounts_then_success_item_new_price_rule
    price_rule = PriceRule.new(type: "ITEM_NEW_PRICE_RULE", config: {min_items_to_apply_discount: 4, updated_price: 7.5})
    basic_config = {price: 10.0, num_of_items: 1, price_rule: price_rule}
    assert_equal 10.0, PriceRuleExecutor.amount_with_discounts(**basic_config)
    assert_equal 20.0, PriceRuleExecutor.amount_with_discounts(**basic_config.merge(num_of_items: 2))
    assert_equal 30.0, PriceRuleExecutor.amount_with_discounts(**basic_config.merge(num_of_items: 3))
    assert_equal 30.0, PriceRuleExecutor.amount_with_discounts(**basic_config.merge(num_of_items: 4))
    assert_equal 37.5, PriceRuleExecutor.amount_with_discounts(**basic_config.merge(num_of_items: 5))
    assert_equal 45.0, PriceRuleExecutor.amount_with_discounts(**basic_config.merge(num_of_items: 6))
  end

  def test_when_amount_with_discounts_then_success_item_price_discount_price_rule
    price_rule = PriceRule.new(type: "ITEM_PRICE_DISCOUNT_RULE", config: {min_items_to_apply_discount: 4, price_discount: 0.25})
    basic_config = {price: 10.0, num_of_items: 1, price_rule: price_rule}
    assert_equal 10.0, PriceRuleExecutor.amount_with_discounts(**basic_config)
    assert_equal 20.0, PriceRuleExecutor.amount_with_discounts(**basic_config.merge(num_of_items: 2))
    assert_equal 30.0, PriceRuleExecutor.amount_with_discounts(**basic_config.merge(num_of_items: 3))
    assert_equal 30.0, PriceRuleExecutor.amount_with_discounts(**basic_config.merge(num_of_items: 4))
    assert_equal 37.5, PriceRuleExecutor.amount_with_discounts(**basic_config.merge(num_of_items: 5))
    assert_equal 45.0, PriceRuleExecutor.amount_with_discounts(**basic_config.merge(num_of_items: 6))
  end
end
