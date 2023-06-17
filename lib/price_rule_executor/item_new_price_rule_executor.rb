require_relative 'price_rule_executor_utils'

module ItemNewPriceRuleExecutor
  extend PriceRuleExecutorUtils

  class << self
    def amount_with_discounts(price:, num_of_items:, min_items_for_discount:, updated_price:)
      check_amount("price", price)
      check_counters("num_of_items", num_of_items)
      check_counters("min_items_for_discount", min_items_for_discount)
      check_amount("updated_price", updated_price)
      _calculate_amount(
        price: price,
        num_of_items: num_of_items,
        min_items_for_discount: min_items_for_discount,
        updated_price: updated_price
      )
    end

    private

    def _calculate_amount(price:, num_of_items:, min_items_for_discount:, updated_price:)
      if num_of_items >= min_items_for_discount
        num_of_items * updated_price
      else
        num_of_items * price
      end
    end
  end
end