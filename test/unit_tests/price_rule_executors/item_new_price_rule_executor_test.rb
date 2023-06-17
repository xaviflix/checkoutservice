require_relative '../../test_helper'
require_relative '../../../lib/price_rule_executor/item_new_price_rule_executor'

class ItemNewPriceRuleExecutorTest < Minitest::Test
  def test_when_amount_with_discounts_then_fails_invalid_price
    basic_config = {price: 10.0, num_of_items: nil, min_items_for_discount: nil, updated_price: nil}
    error = assert_raises InvalidPriceRuleExecutorConfig do
      ItemNewPriceRuleExecutor.amount_with_discounts(**basic_config.merge(price: ""))
    end
    assert_equal "Input value price is not a valid. Details price=", error.message
    error = assert_raises InvalidPriceRuleExecutorConfig do
      ItemNewPriceRuleExecutor.amount_with_discounts(**basic_config.merge(price: -1.0))
    end
    assert_equal "Input value price is not a valid. Details price=-1.0", error.message
    error = assert_raises InvalidPriceRuleExecutorConfig do
      ItemNewPriceRuleExecutor.amount_with_discounts(**basic_config.merge(price: 1))
    end
    assert_equal "Input value price is not a valid. Details price=1", error.message
  end

  def test_when_amount_with_discounts_then_fails_invalid_num_of_items
    basic_config = {price: 10.0, num_of_items: 1, min_items_for_discount: nil, updated_price: nil}
    error = assert_raises InvalidPriceRuleExecutorConfig do
      ItemNewPriceRuleExecutor.amount_with_discounts(**basic_config.merge(num_of_items: "A"))
    end
    assert_equal "Input value num_of_items is not a valid. Details num_of_items=A", error.message
    error = assert_raises InvalidPriceRuleExecutorConfig do
      ItemNewPriceRuleExecutor.amount_with_discounts(**basic_config.merge(num_of_items: 2.0))
    end
    assert_equal "Input value num_of_items is not a valid. Details num_of_items=2.0", error.message
    error = assert_raises InvalidPriceRuleExecutorConfig do
      ItemNewPriceRuleExecutor.amount_with_discounts(**basic_config.merge(num_of_items: 0))
    end
    assert_equal "Input value num_of_items is not a valid. Details num_of_items=0", error.message
  end

  def test_when_amount_with_discounts_then_fails_invalid_min_items_for_discount
    basic_config = {price: 10.0, num_of_items: 1, min_items_for_discount: nil, updated_price: nil}
    error = assert_raises InvalidPriceRuleExecutorConfig do
      ItemNewPriceRuleExecutor.amount_with_discounts(**basic_config.merge(min_items_for_discount: "B"))
    end
    assert_equal "Input value min_items_for_discount is not a valid. Details min_items_for_discount=B", error.message
    error = assert_raises InvalidPriceRuleExecutorConfig do
      ItemNewPriceRuleExecutor.amount_with_discounts(**basic_config.merge(min_items_for_discount: 3.4))
    end
    assert_equal "Input value min_items_for_discount is not a valid. Details min_items_for_discount=3.4", error.message
    error = assert_raises InvalidPriceRuleExecutorConfig do
      ItemNewPriceRuleExecutor.amount_with_discounts(**basic_config.merge(min_items_for_discount: -1))
    end
    assert_equal "Input value min_items_for_discount is not a valid. Details min_items_for_discount=-1", error.message
  end

  def test_when_amount_with_discounts_then_fails_invalid_updated_price
    basic_config = {price: 10.0, num_of_items: 1, min_items_for_discount: 4, updated_price: nil}
    error = assert_raises InvalidPriceRuleExecutorConfig do
      ItemNewPriceRuleExecutor.amount_with_discounts(**basic_config.merge(updated_price: "B"))
    end
    assert_equal "Input value updated_price is not a valid. Details updated_price=B", error.message
    error = assert_raises InvalidPriceRuleExecutorConfig do
      ItemNewPriceRuleExecutor.amount_with_discounts(**basic_config.merge(updated_price: -3.4))
    end
    assert_equal "Input value updated_price is not a valid. Details updated_price=-3.4", error.message
    error = assert_raises InvalidPriceRuleExecutorConfig do
      ItemNewPriceRuleExecutor.amount_with_discounts(**basic_config.merge(updated_price: 11))
    end
    assert_equal "Input value updated_price is not a valid. Details updated_price=11", error.message
  end

  def test_when_amount_with_discounts_then_success
    basic_config = {price: 10.0, num_of_items: 1, min_items_for_discount: 4, updated_price: 7.5}
    assert_equal 10.0, ItemNewPriceRuleExecutor.amount_with_discounts(**basic_config)
    assert_equal 20.0, ItemNewPriceRuleExecutor.amount_with_discounts(**basic_config.merge(num_of_items: 2))
    assert_equal 30.0, ItemNewPriceRuleExecutor.amount_with_discounts(**basic_config.merge(num_of_items: 3))
    assert_equal 30.0, ItemNewPriceRuleExecutor.amount_with_discounts(**basic_config.merge(num_of_items: 4))
    assert_equal 37.5, ItemNewPriceRuleExecutor.amount_with_discounts(**basic_config.merge(num_of_items: 5))
    assert_equal 45.0, ItemNewPriceRuleExecutor.amount_with_discounts(**basic_config.merge(num_of_items: 6))
  end
end
