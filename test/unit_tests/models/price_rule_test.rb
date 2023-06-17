require_relative '../../test_helper'
require_relative '../../../models/price_rule_model'

class PriceRuleTest < Minitest::Test
  def setup
    STORAGE.reset
  end

  def test_when_create_price_rule_then_fails_invalid_type
    error = assert_raises InvalidPriceRuleType do
      PriceRule.new(type: nil, config: nil)
    end
    assert_equal "The value  is not a valid price rule type", error.message
    error = assert_raises InvalidPriceRuleType do
      PriceRule.new(type: "WHATEVER", config: nil)
    end
    assert_equal "The value WHATEVER is not a valid price rule type", error.message
  end

  def test_when_create_price_rule_then_fails_invalid_paid_items_count
    error = assert_raises InvalidPriceRuleConfig do
      PriceRule.new(type: "FREE_ITEMS_RULE", config: nil)
    end
    assert_equal "Invalid configuration values. Details: config[paid_items_count]=", error.message
    error = assert_raises InvalidPriceRuleConfig do
      PriceRule.new(type: "FREE_ITEMS_RULE", config: {paid_items_count: 12.23})
    end
    assert_equal "Invalid configuration values. Details: config[paid_items_count]=12.23", error.message
    error = assert_raises InvalidPriceRuleConfig do
      PriceRule.new(type: "FREE_ITEMS_RULE", config: {paid_items_count: 0})
    end
    assert_equal "Invalid configuration values. Details: config[paid_items_count] not positive", error.message
  end

  def test_when_create_price_rule_then_fails_invalid_free_items_count
    error = assert_raises InvalidPriceRuleConfig do
      PriceRule.new(type: "FREE_ITEMS_RULE", config: {paid_items_count: 1})
    end
    assert_equal "Invalid configuration values. Details: config[free_items_count]=", error.message
    error = assert_raises InvalidPriceRuleConfig do
      PriceRule.new(type: "FREE_ITEMS_RULE", config: {paid_items_count: 1, free_items_count: 12.23})
    end
    assert_equal "Invalid configuration values. Details: config[free_items_count]=12.23", error.message
    error = assert_raises InvalidPriceRuleConfig do
      PriceRule.new(type: "FREE_ITEMS_RULE", config: {paid_items_count: 1, free_items_count: -1})
    end
    assert_equal "Invalid configuration values. Details: config[free_items_count] not positive", error.message
  end

  def test_when_create_price_rule_then_fails_invalid_min_items_to_apply_new_price
    error = assert_raises InvalidPriceRuleConfig do
      PriceRule.new(type: "ITEM_NEW_PRICE_RULE", config: nil)
    end
    assert_equal "Invalid configuration values. Details: Min items value () is invalid", error.message
    error = assert_raises InvalidPriceRuleConfig do
      PriceRule.new(type: "ITEM_NEW_PRICE_RULE", config: {min_items_to_apply_discount: 12.23})
    end
    assert_equal "Invalid configuration values. Details: Min items value (12.23) is invalid", error.message
    error = assert_raises InvalidPriceRuleConfig do
      PriceRule.new(type: "ITEM_NEW_PRICE_RULE", config: {min_items_to_apply_discount: 0})
    end
    assert_equal "Invalid configuration values. Details: Min items value not positive", error.message
  end

  def test_when_create_price_rule_then_fails_invalid_updated_price
    error = assert_raises InvalidPriceRuleConfig do
      PriceRule.new(type: "ITEM_NEW_PRICE_RULE", config: {min_items_to_apply_discount: 1})
    end
    assert_equal "Invalid configuration values. Details: Updated price () is invalid", error.message
    error = assert_raises InvalidPriceRuleConfig do
      PriceRule.new(type: "ITEM_NEW_PRICE_RULE", config: {min_items_to_apply_discount: 1, updated_price: 12})
    end
    assert_equal "Invalid configuration values. Details: Updated price (12) is invalid", error.message
    error = assert_raises InvalidPriceRuleConfig do
      PriceRule.new(type: "ITEM_NEW_PRICE_RULE", config: {min_items_to_apply_discount: 1, updated_price: -1.0})
    end
    assert_equal "Invalid configuration values. Details: Updated price not positive", error.message
  end

  def test_when_create_price_rule_then_fails_invalid_min_items_to_apply_discount
    error = assert_raises InvalidPriceRuleConfig do
      PriceRule.new(type: "ITEM_PRICE_DISCOUNT_RULE", config: nil)
    end
    assert_equal "Invalid configuration values. Details: Min items value () is invalid", error.message
    error = assert_raises InvalidPriceRuleConfig do
      PriceRule.new(type: "ITEM_PRICE_DISCOUNT_RULE", config: {min_items_to_apply_discount: 12.23})
    end
    assert_equal "Invalid configuration values. Details: Min items value (12.23) is invalid", error.message
    error = assert_raises InvalidPriceRuleConfig do
      PriceRule.new(type: "ITEM_PRICE_DISCOUNT_RULE", config: {min_items_to_apply_discount: 0})
    end
    assert_equal "Invalid configuration values. Details: Min items value not positive", error.message
  end

  def test_when_create_price_rule_then_fails_invalid_price_discount
    error = assert_raises InvalidPriceRuleConfig do
      PriceRule.new(type: "ITEM_PRICE_DISCOUNT_RULE", config: {min_items_to_apply_discount: 1})
    end
    assert_equal "Invalid configuration values. Details: Price discount () is invalid", error.message
    error = assert_raises InvalidPriceRuleConfig do
      PriceRule.new(type: "ITEM_PRICE_DISCOUNT_RULE", config: {min_items_to_apply_discount: 1, price_discount: 12})
    end
    assert_equal "Invalid configuration values. Details: Price discount (12) is invalid", error.message
    error = assert_raises InvalidPriceRuleConfig do
      PriceRule.new(type: "ITEM_PRICE_DISCOUNT_RULE", config: {min_items_to_apply_discount: 1, price_discount: -1.0})
    end
    assert_equal "Invalid configuration values. Details: Price discount not positive", error.message
    error = assert_raises InvalidPriceRuleConfig do
      PriceRule.new(type: "ITEM_PRICE_DISCOUNT_RULE", config: {min_items_to_apply_discount: 1, price_discount: 0.75})
    end
    assert_equal "Invalid configuration values. Details: Price discount above 50.0%", error.message
  end

  def test_when_create_free_items_price_rule_then_success
    price_rule = PriceRule.new(type: "FREE_ITEMS_RULE", config: {paid_items_count: 2, free_items_count: 1})
    assert_equal 2, price_rule.paid_items_count
    assert_equal 1, price_rule.free_items_count
    assert_nil price_rule.min_items_for_discount
    assert_nil price_rule.updated_price
    assert_nil price_rule.price_discount
    end

  def test_when_create_item_new_price_rule_then_success
    price_rule = PriceRule.new(type: "ITEM_NEW_PRICE_RULE", config: {min_items_to_apply_discount: 1, updated_price: 8.88})
    assert_nil price_rule.paid_items_count
    assert_nil price_rule.free_items_count
    assert_equal 1, price_rule.min_items_for_discount
    assert_equal 8.88, price_rule.updated_price
    assert_nil price_rule.price_discount
  end

  def test_when_create_item_price_discount_price_rule_then_success
    price_rule = PriceRule.new(type: "ITEM_PRICE_DISCOUNT_RULE", config: {min_items_to_apply_discount: 1, price_discount: 0.30})
    assert_nil price_rule.paid_items_count
    assert_nil price_rule.free_items_count
    assert_equal 1, price_rule.min_items_for_discount
    assert_nil price_rule.updated_price
    assert_equal 0.30, price_rule.price_discount
  end
end
