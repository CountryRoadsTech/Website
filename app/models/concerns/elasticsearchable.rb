# Elasticsearchable Concern adds Elasticsearch functionality to the model it is included in.
module Elasticsearchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    # Elasticsearch Model Callbacks automatically updates the Elasticsearch index when a model is
    # created/updated/destroyed.
    include Elasticsearch::Model::Callbacks

    # Configure the callbacks to perform asynchronously.
    after_save    { ElasticsearchIndexer.perform_async(:index, self.id) }
    after_destroy { ElasticsearchIndexer.perform_async(:delete, self.id) }
  end
end
