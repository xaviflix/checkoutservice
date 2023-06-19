require_relative '../../test_helper'
require_relative '../../../models/product_model'
require_relative '../../../service/cart_checkout_service'

class CartCheckoutServiceTest < Minitest::Test
  def setup
    STORAGE.reset
    _create_test_scenario
    @cart_checkout_service = CartCheckoutService.new(storage: STORAGE)
    @cart_checkout_service.clear # Reset accumulated data from previous test
    super
  end

  def test_when_product_scan_then_fails_invalid_code
    assert_equal "Invalid product code", @cart_checkout_service.scan("PRD-UNKNOWN")
  end

  def test_when_product_scan_then_success
    assert_equal 1.11, @cart_checkout_service.scan("PRD1")
    assert_equal 2.22, @cart_checkout_service.scan("PRD2")
  end

  def test_when_calc_total_without_product_then_success
    assert_equal 0.00, @cart_checkout_service.total
  end

  def test_when_calc_total_success
    assert_equal 1.11, @cart_checkout_service.scan("PRD1")
    assert_equal 1.11, @cart_checkout_service.total
    assert_equal 1.11, @cart_checkout_service.scan("PRD1")
    assert_equal 2.22, @cart_checkout_service.total
    assert_equal 2.22, @cart_checkout_service.scan("PRD2")
    assert_equal 4.44, @cart_checkout_service.total
  end

  def test_when_calc_total_after_basket_clear_success
    assert_equal 1.11, @cart_checkout_service.scan("PRD1")
    assert_equal 1.11, @cart_checkout_service.total
    @cart_checkout_service.clear
    assert_equal 0.00, @cart_checkout_service.total
  end

  private

  def _create_test_scenario
    prd1 = Product.new(name: "Product 1", code: "PRD1", price: 1.11)
    prd1.save
    prd2 = Product.new(name: "Product 2", code: "PRD2", price: 2.22)
    prd2.save
  end
end
