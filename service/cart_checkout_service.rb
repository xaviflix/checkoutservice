require_relative '../lib/price_rule_executor/price_rule_executor'
require_relative '../utils/types_helper'

class CartCheckoutService
  include TypesHelper

  def initialize(storage:)
    @storage = storage
    @card_items = {}
  end

  def scan(cart_item_code)
    product = _load_product(cart_item_code)
    if product
      if @card_items[product.code].nil?
        @card_items[product.code] = [product]
      else
        @card_items[product.code].append(product)
      end
      product.price
    else
      "Invalid product code"
    end
  end

  def clear
    @card_items.clear
  end

  def total
    total_amount = 0.0
    @card_items.each do |_, product_array|
      total_amount += _total_amount_with_discounts(product_array)
    end
    to_money(total_amount)
  end

  private

  def _load_product(code)
    @storage.product_by_code(code)
  end

  def _total_amount_with_discounts(product_array)
    product = product_array.first
    product_applicable_price_rule = @storage.product_applicable_price_rule_by_product_id(product.id)
    if product_applicable_price_rule
      price_rule = @storage.price_rule_by_id(product_applicable_price_rule.price_rule_id)
      PriceRuleExecutor.amount_with_discounts(price: product.price,
                                              num_of_items: product_array.length,
                                              price_rule: price_rule)
    else
      product.price * product_array.length
    end
  rescue UnsupportedPriceRuleType => config_error
    # In case of configuration error report it, but do block the operation, just do not apply discounts
    product.price * product_array.length
  end
end
