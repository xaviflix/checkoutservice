require_relative '../../test_helper'
require_relative '../../../models/product_model'

class ProductTest < Minitest::Test
  def setup
    STORAGE.reset
  end

  def test_when_create_product_then_fails_invalid_name
    error = assert_raises InvalidModelValue do
      Product.new(name: nil, code: nil, price: nil)
    end
    assert_equal "Input value name is not a valid. Details name=", error.message
    error = assert_raises InvalidModelValue do
      Product.new(name: "", code: nil, price: nil)
    end
    assert_equal "Input value name is not a valid. Details name=", error.message
  end

  def test_when_create_product_then_fails_invalid_code
    error = assert_raises InvalidModelValue do
      Product.new(name: "Test", code: nil, price: nil)
    end
    assert_equal "Input value code is not a valid. Details code=", error.message
    error = assert_raises InvalidModelValue do
      Product.new(name: "Test", code: "", price: nil)
    end
    assert_equal "Input value code is not a valid. Details code=", error.message
  end

  def test_when_create_product_then_fails_invalid_price
    error = assert_raises InvalidModelValue do
      Product.new(name: "Test", code: "XXX", price: nil)
    end
    assert_equal "Input value price is not a valid. Details price=", error.message
    error = assert_raises InvalidModelValue do
      Product.new(name: "Test", code: "XXX", price: "10.0")
    end
    assert_equal "Input value price is not a valid. Details price=10.0", error.message
    error = assert_raises InvalidModelValue do
      Product.new(name: "Test", code: "XXX", price: 10)
    end
    assert_equal "Input value price is not a valid. Details price=10", error.message
    error = assert_raises InvalidModelValue do
      Product.new(name: "Test", code: "XXX", price: -10.0)
    end
    assert_equal "Input value price is not a valid. Details price=-10.0", error.message
  end

  def test_when_create_product_then_success
    product = Product.new(name: "Product Name", code: "Product Code", price: 10.0)
    assert_equal "Product Name", product.name
    assert_equal "Product Code", product.code
    assert_equal 10.0, product.price
  end

  def test_when_create_product_then_fails_duplicated_code
    product = Product.new(name: "Product Name", code: "Product Code", price: 10.0)
    product.save
    error = assert_raises AlreadyExistingProduct do
      Product.new(name: "Product Name Other", code: "Product Code", price: 15.0)
    end
    assert_equal "Product with code Product Code already exist", error.message
  end
end
