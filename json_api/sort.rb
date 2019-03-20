module JsonApi
  class Sort
    attr_reader :field, :direction

    def initialize(field, direction)
      @field = field
      @direction = direction
    end

    def apply(collection)
      table = collection.none.klass.table_name
      order_field = field.include?('.') ? field : [table, field].join('.')
      order = "#{order_field} #{direction.to_s.upcase}"
      collection.order(order)
    end
  end
end