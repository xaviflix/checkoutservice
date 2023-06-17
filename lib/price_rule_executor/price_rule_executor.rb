require_relative '../../utils/exceptions'
require_relative '../../models/price_rule_model'
require_relative 'free_items_rule_executor'
require_relative 'item_new_price_rule_executor'
require_relative 'item_price_discount_rule_executor'

module PriceRuleExecutor
  def self.amount_with_discounts(price:, num_of_items:, price_rule:)
    case price_rule.type
    when PriceRule::FREE_ITEMS_RULE
      FreeItemsRuleExecutor.amount_with_discounts(
        price: price,
        num_of_items: num_of_items,
        paid_items_count: price_rule.paid_items_count,
        free_items_count: price_rule.free_items_count
      )
    when PriceRule::ITEM_NEW_PRICE_RULE
      ItemNewPriceRuleExecutor.amount_with_discounts(
        price: price,
        num_of_items: num_of_items,
        min_items_for_discount: price_rule.min_items_for_discount,
        updated_price: price_rule.updated_price
      )
    when PriceRule::ITEM_PRICE_DISCOUNT_RULE
      ItemPriceDiscountRuleExecutor.amount_with_discounts(
        price: price,
        num_of_items: num_of_items,
        min_items_for_discount: price_rule.min_items_for_discount,
        discount_percentage: price_rule.price_discount
      )
    else
      raise UnsupportedPriceRuleType.new(price_rule.type)
    end
  end
end