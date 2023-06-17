require_relative 'error_codes'

class CartCheckoutBaseError < StandardError
  attr_reader :error_code
  attr_reader :public_msg

  def initialize(msg:, error_code:, public_msg: nil)
    @error_code = error_code
    @public_msg = public_msg || msg
    super(msg)
  end
end

class InvalidModelValue < CartCheckoutBaseError
  def initialize(field_name, field_value)
    public_msg = "Input value #{field_name} is not a valid"
    msg = "#{public_msg}. Details #{field_name}=#{field_value}"
    super(msg: msg, error_code: ErrorCodes::INVALID_MODEL_VALUE, public_msg: public_msg)
  end
end

class AlreadyExistingProduct < CartCheckoutBaseError
  def initialize(code)
    msg = "Product with code #{code} already exist"
    super(msg: msg, error_code: ErrorCodes::ALREADY_EXISTING_PRODUCT)
  end
end

class InvalidPriceRuleType < CartCheckoutBaseError
  def initialize(price_type)
    msg = "The value #{price_type} is not a valid price rule type"
    super(msg: msg, error_code: ErrorCodes::INVALID_PRICE_RULE_TYPE)
  end
end

class InvalidPriceRuleConfig < CartCheckoutBaseError
  def initialize(details)
    public_msg = "Invalid configuration values"
    msg = "#{public_msg}. Details: #{details}"
    super(msg: msg, error_code: ErrorCodes::INVALID_PRICE_RULE_CONFIG, public_msg: public_msg)
  end
end

class AlreadyExistingPricesRulesForProduct < CartCheckoutBaseError
  def initialize(product_id)
    public_msg = "Product has already set prices rules"
    msg = "#{public_msg}. Product ID=#{product_id}"
    super(msg: msg, error_code: ErrorCodes::ALREADY_EXISTING_PRODUCT, public_msg: public_msg)
  end
end

class UnsupportedPriceRuleType < CartCheckoutBaseError
  def initialize(price_rule_type)
    public_msg = "Unsupported price rule configuration."
    msg = "#{public_msg} Details: Unsupported price rule type #{price_rule_type}"
    super(msg: msg, error_code: ErrorCodes::UNSUPPORTED_PRICE_RULE_CONFIGURATION, public_msg: public_msg)
  end
end

class InvalidPriceRuleExecutorConfig < CartCheckoutBaseError
  def initialize(field_name, field_value)
    public_msg = "Input value #{field_name} is not a valid"
    msg = "#{public_msg}. Details #{field_name}=#{field_value}"
    super(msg: msg, error_code: ErrorCodes::INVALID_PRICE_RULE_EXECUTOR_CONFIG, public_msg: public_msg)
  end
end