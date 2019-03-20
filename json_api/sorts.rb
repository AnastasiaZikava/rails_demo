module JsonApi
  class Sorts
    attr_reader :sorts

    def initialize(sorts = [])
      @sorts = sorts
    end

    def apply(collection)
      return collection if sorts.empty?
      sorts.inject(collection) { |sortable, sort| sort.apply(sortable) }
    end
  end
end