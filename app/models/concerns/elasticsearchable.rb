# Elasticsearchable Concern adds Elasticsearch functionality to the model it is included in.
module Elasticsearchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    # Elasticsearch Model Callbacks automatically updates the Elasticsearch index when a model is
    # created/updated/destroyed.
    include Elasticsearch::Model::Callbacks

    # Configure the callbacks to perform asynchronously.
    after_save do |model|
      ElasticsearchIndexer.perform_async(:index, model.class.to_s.downcase, model.id, record_body = model.__elasticsearch__.as_indexed_json)
    end
    after_destroy do |model|
      ElasticsearchIndexer.perform_async(:delete, model, model.id)
    end
  end
end
