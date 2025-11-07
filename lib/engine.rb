# frozen_string_literal: true

module ::DiscourseDatashare
  CATEGORY_CREATED_BY_FIELD = 'created_by_dataconnect'.freeze
  TOPIC_DOCUMENT_INDEX_FIELD = 'datashare_document_index'.freeze
  TOPIC_DOCUMENT_ID_FIELD = 'datashare_document_id'.freeze
  TOPIC_DOCUMENT_ROUTING_FIELD = 'datashare_document_routing'.freeze
  TOPIC_DOCUMENT_TITLE_FIELD = 'datashare_document_title'.freeze
  TOPIC_DOCUMENT_CONTENT_TYPE_FIELD = 'datashare_document_content_type'.freeze
  TOPIC_DOCUMENT_URL_FIELD = 'datashare_document_url'.freeze

  class Engine < ::Rails::Engine
    engine_name PLUGIN_NAME
    isolate_namespace DiscourseDatashare
    config.autoload_paths << File.join(config.root, 'lib')
  end
end
