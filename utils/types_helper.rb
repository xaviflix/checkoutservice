module TypesHelper
  def is_empty?(value)
    value.nil? || value.empty?
  end

  def is_int?(value)
    !value.nil? && value.is_a?(Integer)
  end

  def is_decimal?(value)
    !value.nil? && value.is_a?(Float)
  end

  def to_money(value)
    value.round(2)
  end
end