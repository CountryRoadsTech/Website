# frozen_string_literal: true

class ElasticsearchIndexer < ApplicationJob
  sidekiq_options queue: 'elasticsearch', retry: false

  Logger = Sidekiq.logger.level == Logger::DEBUG ? Sidekiq.logger : nil
  Client = Elasticsearch::Client.new host: ENV['ELASTICSEARCH_HOST'], logger: Logger

  def perform(operation, record, record_id)
    logger.debug [operation, "ID: #{record_id}"]
    record_name = record.class.to_s

    case operation.to_s
    when /index/
      record = find(record_id)
      Client.index(index: record_name.pluralize, type: record_name, id: record.id, body: __elasticsearch__.as_indexed_json)
    when /delete/
      begin
        Client.delete(index: record_name.pluralize, type: record_name, id: record_id)
      rescue Elasticsearch::Transport::Transport::Errors::NotFound
        logger.debug "Model not found with ID: #{record_id}"
      end
    else raise ArgumentError, "Unknown Elasticsearch operation '#{operation}'"
    end
  end
end
