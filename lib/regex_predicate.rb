require_relative "predicate"
class RegexPredicate < Predicate
  def initialize(expression)
    super(expression)
  end

  def match(value)
      return expression.match value[:name]
  end
end