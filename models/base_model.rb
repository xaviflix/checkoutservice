require_relative '../storage/database_storage'
require_relative '../utils/types_helper'

class BaseModel
  include TypesHelper

  attr_accessor :id

  def initialize(** args)
    @storage = DatabaseStorage.instance
  end

  def save
    @id = @storage.add(self)
  end
end