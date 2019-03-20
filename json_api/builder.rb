module JsonApi
  class Builder
    class << self
      def collection(relation, params)
        params = params.to_h.deep_transform_keys(&:to_sym)
        options = { pagination: pagination(params), sorts: sorts(params), filter: filter(params) }
        JsonApi::Collection.new(relation, options)
      end

      def filter(params)
        return JsonApi::Filter.new unless params[:filter]

        rules = params[:filter].values.map do |filter|
          value = filter[:value].try(:values) || filter[:value]
          operator = filter[:operator] ? filter[:operator].to_sym : JsonApi::Rule::DEFAULT_OPERATOR
          JsonApi::Rule.new(filter[:field], value, operator)
        end

        JsonApi::Filter.new(rules, params[:filter_logic])
      end

      def sorts(params)
        return JsonApi::Sorts.new unless params[:sort]

        sort_pair = -> field { field.starts_with?('-') ? [field[1..-1], :desc] : [field, :asc] }

        sorts = params[:sort]
          .split(',')
          .map(&:strip)
          .map(&sort_pair)
          .to_h
          .deep_transform_keys! { |key| key.to_s.underscore }
          .map { |field, direction| JsonApi::Sort.new(field.downcase, direction.downcase.to_sym == :asc ? :asc : :desc) }

        JsonApi::Sorts.new(sorts)
      end

      def pagination(params)
        offset = Integer(params.dig(:page, :offset) || JsonApi::Pagination::DEFAULT_OFFSET)
        limit = Integer(params.dig(:page, :limit) || JsonApi::Pagination::DEFAULT_LIMIT)

        JsonApi::Pagination.new(limit, offset)
      end
    end
  end
end