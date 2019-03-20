module JsonApi
  class Pagination
    attr_reader :limit, :offset
    attr_accessor :count

    DEFAULT_LIMIT = 20
    DEFAULT_OFFSET = 0

    def initialize(limit, offset)
      @limit = limit
      @offset = offset
    end

    def apply(collection)
      self.count = collection.count
      collection.limit(limit).offset(offset)
    end
  end
end