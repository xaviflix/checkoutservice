require 'ostruct'
require_relative '../utils/exceptions'
require_relative 'base_model'

class PriceRule < BaseModel
  attr_reader :type

  FREE_ITEMS_RULE = "FREE_ITEMS_RULE"
  ITEM_NEW_PRICE_RULE = "ITEM_NEW_PRICE_RULE"
  ITEM_PRICE_DISCOUNT_RULE = "ITEM_PRICE_DISCOUNT_RULE"
  PRICE_RULES = [FREE_ITEMS_RULE, ITEM_NEW_PRICE_RULE, ITEM_PRICE_DISCOUNT_RULE]
  FREE_ITEMS_RULE_CONFIG_KEYS = %w[paid_items_count free_items_count]
  MAX_DISCOUNT_PERCENTAGE = 50.0

  def initialize(type: ,config:)
    super
    _check_input_values(type, config || {})
    @id = nil
    @type = type
    @config = OpenStruct.new(config)
  end

  def paid_items_count
    @type == FREE_ITEMS_RULE ? @config.paid_items_count : nil
  end

  def free_items_count
    @type == FREE_ITEMS_RULE ? @config.free_items_count : nil
  end

  def min_items_for_discount
    [ITEM_NEW_PRICE_RULE, ITEM_PRICE_DISCOUNT_RULE].include?(@type) ? @config.min_items_to_apply_discount : nil
  end

  def updated_price
    @type == ITEM_NEW_PRICE_RULE ? @config.updated_price : nil
  end

  def price_discount
    @type == ITEM_PRICE_DISCOUNT_RULE ? @config.price_discount : nil
  end

  private

  def _check_input_values(type, config)
    case type
    when FREE_ITEMS_RULE
      _check_free_items_rule_config(config)
    when ITEM_NEW_PRICE_RULE
      _check_new_price_rule_config(config)
    when ITEM_PRICE_DISCOUNT_RULE
      _check_price_discount_rule_config(config)
    else
      raise InvalidPriceRuleType.new(type) unless PRICE_RULES.include?(type)
    end
  end

  def _check_free_items_rule_config(config)
    config = config.transform_keys {|k| k.to_s }

    FREE_ITEMS_RULE_CONFIG_KEYS.each do |config_key|
      config_value = config[config_key]
      raise InvalidPriceRuleConfig.new("config[#{config_key}]=#{config_value}") unless is_int?(config_value)
      raise InvalidPriceRuleConfig.new("config[#{config_key}] not positive") unless config_value.positive?
    end

    if config["free_items_count"] > config["paid_items_count"]
      details = "Free items (#{config["free_items_count"] }) > paid items (#{config["paid_items_count"]})"
      raise InvalidPriceRuleConfig.new(details)
    end
  end

  def _check_new_price_rule_config(config)
    config = config.transform_keys {|k| k.to_s }
    min_items_to_apply_discount = config["min_items_to_apply_discount"]
    updated_price = config["updated_price"]

    raise InvalidPriceRuleConfig.new("Min items value (#{min_items_to_apply_discount}) is invalid") unless is_int?(min_items_to_apply_discount)
    raise InvalidPriceRuleConfig.new("Min items value not positive") unless min_items_to_apply_discount.positive?
    raise InvalidPriceRuleConfig.new("Updated price (#{updated_price}) is invalid") unless is_decimal?(updated_price)
    raise InvalidPriceRuleConfig.new("Updated price not positive") unless updated_price.positive?
  end

  def _check_price_discount_rule_config(config)
    config = config.transform_keys {|k| k.to_s }
    min_items_to_apply_discount = config["min_items_to_apply_discount"]
    price_discount = config["price_discount"]

    raise InvalidPriceRuleConfig.new("Min items value (#{min_items_to_apply_discount}) is invalid") unless is_int?(min_items_to_apply_discount)
    raise InvalidPriceRuleConfig.new("Min items value not positive") unless min_items_to_apply_discount.positive?
    raise InvalidPriceRuleConfig.new("Price discount (#{price_discount}) is invalid") unless is_decimal?(price_discount)
    raise InvalidPriceRuleConfig.new("Price discount not positive") unless price_discount.positive?
    raise InvalidPriceRuleConfig.new("Price discount above #{MAX_DISCOUNT_PERCENTAGE}%") if 100 * price_discount > MAX_DISCOUNT_PERCENTAGE
  end
end

