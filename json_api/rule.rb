module JsonApi
  class Rule
    attr_accessor :model, :field, :value, :operator, :table, :path

    DEFAULT_OPERATOR = :is

    def initialize(field, value, operator)
      field_path = field.split('.')
      @field = field_path.pop
      @table = field_path.last
      @path = field_path.join('.')
      @value = value
      @operator = operator
    end

    def build_for(collection)
      model = table ? table.singularize.camelize.constantize : collection.none.klass.name.constantize
      model.arel_table[field.to_sym].send(*predicate)
    end

    private

    def predicate
      case operator
      when :contains then [:matches, "%#{value}%"]
      when :begin then [:matches, "#{value}%"]
      when :end then [:matches, "%#{value}"]
      when :is then [:eq, value]
      when :between then [:between, value.first..value.last]
      when :in then [:in, value]
      when :not_in then [:not_in, value]
      else [:eq, value]
      end
    end
  end
end