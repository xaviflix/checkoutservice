require_relative 'price_rule_executor_utils'

module FreeItemsRuleExecutor
  extend PriceRuleExecutorUtils

  class << self
    def amount_with_discounts(price:, num_of_items:, paid_items_count:, free_items_count:)
      check_amount("price", price)
      check_counters("num_of_items", num_of_items)
      check_counters("paid_items_count", paid_items_count)
      check_counters("free_items_count", free_items_count)
      _calculate_amount(
        price: price,
        num_of_items: num_of_items,
        paid_items_count: paid_items_count,
        free_items_count: free_items_count
      )
    end

    private

    def _calculate_amount(price:, num_of_items:, paid_items_count:, free_items_count:)
      paid_plus_free_items = paid_items_count + free_items_count
      num_of_free_items = num_of_items / paid_plus_free_items
      num_of_items * price - num_of_free_items * price
    end
  end
end