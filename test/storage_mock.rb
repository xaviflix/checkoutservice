require_relative '../storage/storage'

class StorageMock < Storage
  def initialize
    @products_table = {}
    @price_rules_table = {}
    @product_applicable_price_rules_table = {}
  end

  def reset
    @products_table.clear
    @price_rules_table.clear
    @product_applicable_price_rules_table.clear
  end

  def add(model_instance)
    if model_instance.class.name == "Product"
      _add_product(model_instance)
    elsif model_instance.class.name == "PriceRule"
      _add_price_rule(model_instance)
    elsif model_instance.class.name == "ProductApplicablePriceRule"
      _add_product_applicable_price_rule(model_instance)
    end
  end

  def product_by_code(code)
    @products_table[code]
  end

  def product_code_exist?(code)
    !@products_table[code].nil?
  end

  def price_rule_by_id(price_rule_id)
    @price_rules_table[price_rule_id]
  end

  def product_applicable_price_rule_by_product_id(product_id)
    @product_applicable_price_rules_table[product_id]
  end

  private

  def _add_product(product)
    raise StandardError.new("Duplicated Unique Index") unless @products_table[product.code].nil?
    id = @products_table.length + 1
    @products_table[product.code] = product
    product.id = id
    id
  end

  def _add_price_rule(price_rule)
    id = @price_rules_table.length + 1
    @price_rules_table[id] = price_rule
    price_rule.id = id
    id
  end

  def _add_product_applicable_price_rule(product_applicable_price_rule)
    id = @product_applicable_price_rules_table.length + 1
    product_applicable_price_rule.id = id
    @product_applicable_price_rules_table[product_applicable_price_rule.product_id] = product_applicable_price_rule
    id
  end
end