require_relative '../storage/storage'
require_relative '../utils/types_helper'

class BaseModel
  include TypesHelper

  attr_accessor :id

  def initialize(** args)
    @storage = STORAGE
  end

  def save
    @id = @storage.add(self)
  end
end