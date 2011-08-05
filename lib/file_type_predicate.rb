require_relative "predicate"

class FileTypePredicate < Predicate
  def initialize(file_type)
    super(file_type)
  end

  def match(value)
      return value[:name].end_with? @rule
  end
end