require_relative 'price_rule_executor_utils'

module ItemPriceDiscountRuleExecutor
  extend PriceRuleExecutorUtils

  class << self
    def amount_with_discounts(price:, num_of_items:, min_items_for_discount:, discount_percentage:)
      check_amount("price", price)
      check_counters("num_of_items", num_of_items)
      check_counters("min_items_for_discount", min_items_for_discount)
      check_amount("discount_percentage", discount_percentage)
      _calculate_amount(
        price: price,
        num_of_items: num_of_items,
        min_items_for_discount: min_items_for_discount,
        discount_percentage: discount_percentage
      )
    end

    private

    def _calculate_amount(price:, num_of_items:, min_items_for_discount:, discount_percentage:)
      if num_of_items >= min_items_for_discount
        num_of_items * (price * (1.0 - discount_percentage))
      else
        num_of_items * price
      end
    end
  end
end