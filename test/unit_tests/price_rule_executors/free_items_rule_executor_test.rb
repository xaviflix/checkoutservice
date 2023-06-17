require_relative '../../test_helper'
require_relative '../../../lib/price_rule_executor/free_items_rule_executor'

class FreeItemsRuleExecutorTest < Minitest::Test
  def test_when_amount_with_discounts_then_fails_invalid_price
    basic_config = {price: 10.0, num_of_items: nil, paid_items_count: nil, free_items_count: nil}
    error = assert_raises InvalidPriceRuleExecutorConfig do
      FreeItemsRuleExecutor.amount_with_discounts(**basic_config.merge(price: ""))
    end
    assert_equal "Input value price is not a valid. Details price=", error.message
    error = assert_raises InvalidPriceRuleExecutorConfig do
      FreeItemsRuleExecutor.amount_with_discounts(**basic_config.merge(price: -1.0))
    end
    assert_equal "Input value price is not a valid. Details price=-1.0", error.message
    error = assert_raises InvalidPriceRuleExecutorConfig do
      FreeItemsRuleExecutor.amount_with_discounts(**basic_config.merge(price: 1))
    end
    assert_equal "Input value price is not a valid. Details price=1", error.message
  end

  def test_when_amount_with_discounts_then_fails_invalid_num_of_items
    basic_config = {price: 20.0, num_of_items: nil, paid_items_count: nil, free_items_count: nil}
    error = assert_raises InvalidPriceRuleExecutorConfig do
      FreeItemsRuleExecutor.amount_with_discounts(**basic_config.merge(num_of_items: "A"))
    end
    assert_equal "Input value num_of_items is not a valid. Details num_of_items=A", error.message
    error = assert_raises InvalidPriceRuleExecutorConfig do
      FreeItemsRuleExecutor.amount_with_discounts(**basic_config.merge(num_of_items: 2.0))
    end
    assert_equal "Input value num_of_items is not a valid. Details num_of_items=2.0", error.message
    error = assert_raises InvalidPriceRuleExecutorConfig do
      FreeItemsRuleExecutor.amount_with_discounts(**basic_config.merge(num_of_items: 0))
    end
    assert_equal "Input value num_of_items is not a valid. Details num_of_items=0", error.message
  end

  def test_when_amount_with_discounts_then_fails_invalid_paid_items_count
    basic_config = {price: 20.0, num_of_items: 5, paid_items_count: nil, free_items_count: nil}
    error = assert_raises InvalidPriceRuleExecutorConfig do
      FreeItemsRuleExecutor.amount_with_discounts(**basic_config.merge(paid_items_count: "B"))
    end
    assert_equal "Input value paid_items_count is not a valid. Details paid_items_count=B", error.message
    error = assert_raises InvalidPriceRuleExecutorConfig do
      FreeItemsRuleExecutor.amount_with_discounts(**basic_config.merge(paid_items_count: 3.4))
    end
    assert_equal "Input value paid_items_count is not a valid. Details paid_items_count=3.4", error.message
    error = assert_raises InvalidPriceRuleExecutorConfig do
      FreeItemsRuleExecutor.amount_with_discounts(**basic_config.merge(paid_items_count: -1))
    end
    assert_equal "Input value paid_items_count is not a valid. Details paid_items_count=-1", error.message
  end

  def test_when_amount_with_discounts_then_fails_invalid_free_items_count
    basic_config = {price: 20.0, num_of_items: 5, paid_items_count: 2, free_items_count: nil}
    error = assert_raises InvalidPriceRuleExecutorConfig do
      FreeItemsRuleExecutor.amount_with_discounts(**basic_config.merge(free_items_count: "B"))
    end
    assert_equal "Input value free_items_count is not a valid. Details free_items_count=B", error.message
    error = assert_raises InvalidPriceRuleExecutorConfig do
      FreeItemsRuleExecutor.amount_with_discounts(**basic_config.merge(free_items_count: 3.4))
    end
    assert_equal "Input value free_items_count is not a valid. Details free_items_count=3.4", error.message
    error = assert_raises InvalidPriceRuleExecutorConfig do
      FreeItemsRuleExecutor.amount_with_discounts(**basic_config.merge(free_items_count: -1))
    end
    assert_equal "Input value free_items_count is not a valid. Details free_items_count=-1", error.message
  end

  def test_when_amount_with_discounts_then_1_free_for_each_1_paid_success
    basic_config = {price: 10.0, num_of_items: 1, paid_items_count: 1, free_items_count: 1}
    assert_equal 10.0, FreeItemsRuleExecutor.amount_with_discounts(**basic_config)
    assert_equal 10.0, FreeItemsRuleExecutor.amount_with_discounts(**basic_config.merge(num_of_items: 2))
    assert_equal 20.0, FreeItemsRuleExecutor.amount_with_discounts(**basic_config.merge(num_of_items: 3))
    assert_equal 20.0, FreeItemsRuleExecutor.amount_with_discounts(**basic_config.merge(num_of_items: 4))
    assert_equal 30.0, FreeItemsRuleExecutor.amount_with_discounts(**basic_config.merge(num_of_items: 5))
  end

  def test_when_amount_with_discounts_then_1_free_for_each_2_paid_success
    basic_config = {price: 10.0, num_of_items: 1, paid_items_count: 2, free_items_count: 1}
    assert_equal 10.0, FreeItemsRuleExecutor.amount_with_discounts(**basic_config)
    assert_equal 20.0, FreeItemsRuleExecutor.amount_with_discounts(**basic_config.merge(num_of_items: 2))
    assert_equal 20.0, FreeItemsRuleExecutor.amount_with_discounts(**basic_config.merge(num_of_items: 3))
    assert_equal 30.0, FreeItemsRuleExecutor.amount_with_discounts(**basic_config.merge(num_of_items: 4))
    assert_equal 40.0, FreeItemsRuleExecutor.amount_with_discounts(**basic_config.merge(num_of_items: 5))
    assert_equal 40.0, FreeItemsRuleExecutor.amount_with_discounts(**basic_config.merge(num_of_items: 6))
    assert_equal 50.0, FreeItemsRuleExecutor.amount_with_discounts(**basic_config.merge(num_of_items: 7))
  end
end
