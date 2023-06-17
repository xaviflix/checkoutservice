require_relative '../test_helper'
require_relative '../../models/product_model'
require_relative '../../models/price_rule_model'
require_relative '../../models/product_applicable_price_rule_model'
require_relative '../../service/cart_checkout_service'

class CartCheckoutServiceTest < Minitest::Test
  def setup
    STORAGE.reset
    _create_test_scenario
    @cart_checkout_service = CartCheckoutService.new(storage: STORAGE)
    @cart_checkout_service.clear # Reset accumulated data from previous test
    super
  end

  def test_when_product_list_gr1_sr1_gr1_gr1_cf1_then_success
    assert_equal 3.11, @cart_checkout_service.scan("GR1")
    assert_equal 5.0, @cart_checkout_service.scan("SR1")
    assert_equal 3.11, @cart_checkout_service.scan("GR1")
    assert_equal 3.11, @cart_checkout_service.scan("GR1")
    assert_equal 11.23, @cart_checkout_service.scan("CF1")
    assert_equal 22.45, @cart_checkout_service.total
  end

  def test_when_product_list_gr1_gr1_then_success
    assert_equal 3.11, @cart_checkout_service.scan("GR1")
    assert_equal 3.11, @cart_checkout_service.scan("GR1")
    assert_equal 3.11, @cart_checkout_service.total
  end

  def test_when_product_list_sr1_sr1_gr1_sr1_then_success
    assert_equal 5.0, @cart_checkout_service.scan("SR1")
    assert_equal 5.0, @cart_checkout_service.scan("SR1")
    assert_equal 3.11, @cart_checkout_service.scan("GR1")
    assert_equal 5.0, @cart_checkout_service.scan("SR1")
    assert_equal 16.61, @cart_checkout_service.total
  end

  def test_when_product_list_gr1_cf1_sr1_cf1_cf1_then_success
    assert_equal 3.11, @cart_checkout_service.scan("GR1")
    assert_equal 11.23, @cart_checkout_service.scan("CF1")
    assert_equal 5.0, @cart_checkout_service.scan("SR1")
    assert_equal 11.23, @cart_checkout_service.scan("CF1")
    assert_equal 11.23, @cart_checkout_service.scan("CF1")
    assert_equal 30.57, @cart_checkout_service.total
  end

  private

  def _create_test_scenario
    # Products
    gr1 = Product.new(name: "Green tea", code: "GR1", price: 3.11)
    gr1.save
    sr1 = Product.new(name: "Strawberries", code: "SR1", price: 5.00)
    sr1.save
    cf1 = Product.new(name: "Coffee", code: "CF1", price: 11.23)
    cf1.save
    # Price rules
    free_items_rule =
      PriceRule.new(type: "FREE_ITEMS_RULE", config: {paid_items_count: 1, free_items_count: 1})
    free_items_rule.save
    item_new_price_rule =
      PriceRule.new(type: "ITEM_NEW_PRICE_RULE", config: {min_items_to_apply_discount: 3, updated_price: 4.5})
    item_new_price_rule.save
    item_price_price_discount_rule =
      PriceRule.new(type: "ITEM_PRICE_DISCOUNT_RULE", config: {min_items_to_apply_discount: 3, price_discount: 1.0/3.0})
    item_price_price_discount_rule.save
    # Products & Price rules assignation
    ProductApplicablePriceRule.new(product_id: gr1.id, price_rule_id: free_items_rule.id).save
    ProductApplicablePriceRule.new(product_id: sr1.id, price_rule_id: item_new_price_rule.id).save
    ProductApplicablePriceRule.new(product_id: cf1.id, price_rule_id: item_price_price_discount_rule.id).save
  end
end
