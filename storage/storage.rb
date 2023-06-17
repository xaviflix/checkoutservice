class Storage
  # Define the desired storage interface

  def initialize
    raise NotImplementedError, "This interface needs to be implemented"
  end

  def add(model_instance)
    raise NotImplementedError, "This interface needs to be implemented"
  end

  def product_by_code(code)
    raise NotImplementedError, "This interface needs to be implemented"
  end

  def product_code_exist?(code)
    raise NotImplementedError, "This interface needs to be implemented"
  end

  def price_rule_by_id(price_rule_id)
    raise NotImplementedError, "This interface needs to be implemented"
  end

  def product_applicable_price_rule_by_product_id(product_id)
    raise NotImplementedError, "This interface needs to be implemented"
  end
end