module JsonApi
  class Filter
    attr_accessor :rules, :logic

    DEFAULT_LOGIC = :and

    def initialize(rules = [], logic = nil)
      @logic = logic || DEFAULT_LOGIC
      @rules = rules
    end

    def apply(collection)
      return collection if rules.empty?

      queries = rules.map { |rule| rule.build_for(collection) }
      query = queries[0..-2].reverse.inject(queries.last) { |memo, arel| arel.send(logic, memo) }

      collection.joins(StringPath.translate(rules.map(&:path))).where(query)
    end
  end
end