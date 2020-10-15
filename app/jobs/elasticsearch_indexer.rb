# frozen_string_literal: true

class ElasticsearchIndexer < ApplicationJob
  sidekiq_options queue: 'elasticsearch', retry: true

  Logger = Sidekiq.logger.level == Logger::DEBUG ? Sidekiq.logger : nil
  Client = Elasticsearch::Client.new host: ENV['ELASTICSEARCH_HOST'], logger: Logger

  def perform(operation, record_name, record_id, record_body=nil)
    logger.debug [operation, "ID: #{record_id}"]
    case operation.to_s
    when /index/
      Client.index(index: record_name.pluralize, type: record_name, id: record_id, body: record_body)
    when /delete/
      begin
        Client.delete(index: record_name.pluralize, type: record_name, id: record_id)
      rescue Elasticsearch::Transport::Transport::Errors::NotFound
        logger.debug "Model not found with ID: #{record_id}"
      end
    else raise ArgumentError, "Unknown Elasticsearch operation: '#{operation}'"
    end
  end
end
