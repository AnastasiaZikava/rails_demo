module JsonApi
  module ControllerHelper
    def collection(relation, options = {})
      collection = Builder.collection(relation, params)
      serializer = options.fetch(:serializer, "#{collection.model}Serializer".constantize)
      collection_response(collection, options.merge(serializer: serializer))
    end

    def collection_response(object, options = {})
      serializer = options.fetch(:serializer)
      relation = object.items
      data = serializer.new(relation)
      json_api_response(data.serialized_json, options)
    end

    def json_api_response(object, options = {})
      response.headers['Content-Type'] = 'application/vnd.api+json; charset=utf-8'
      default_options = { status: :ok, adapter: :json_api }
      render json: object, ** default_options.merge(options)
    end
  end
end
