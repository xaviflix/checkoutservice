require_relative '../../utils/exceptions'
require_relative '../../utils/types_helper'
require_relative '../../models/price_rule_model'

module PriceRuleExecutorUtils
  include TypesHelper

  def check_amount(amount_field, amount_value)
    raise InvalidPriceRuleExecutorConfig.new(amount_field, amount_value) unless is_decimal?(amount_value)
    raise InvalidPriceRuleExecutorConfig.new(amount_field, amount_value) unless amount_value.positive?
  end

  def check_counters(count_name, count_value)
    raise InvalidPriceRuleExecutorConfig.new(count_name, count_value) unless is_int?(count_value)
    raise InvalidPriceRuleExecutorConfig.new(count_name, count_value) unless count_value.positive?
  end
end