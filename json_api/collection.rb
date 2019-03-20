module JsonApi
  class Collection
    attr_reader :pagination, :sorts, :filter

    def initialize(relation, options)
      @relation = relation

      @pagination = options.fetch(:pagination)
      @sorts = options.fetch(:sorts)
      @filter = options.fetch(:filter)
    end

    def items
      @items ||= @relation
        .yield_self(&filter.method(:apply))
        .yield_self(&sorts.method(:apply))
        .yield_self(&pagination.method(:apply))
    end

    def model
      @relation.none.klass.name.constantize
    end
  end
end