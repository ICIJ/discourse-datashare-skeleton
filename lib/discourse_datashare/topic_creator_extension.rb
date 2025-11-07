# frozen_string_literal: true

module DiscourseDatashare
  # Extends the TopicCreator to handle add a custom field containing the
  # datashare document ID when creating a topic.
  module TopicCreatorExtension
    def create
      topic = super
      if @opts[TOPIC_DOCUMENT_ID_FIELD].present?
        topic.custom_fields[TOPIC_DOCUMENT_ID_FIELD] = @opts[TOPIC_DOCUMENT_ID_FIELD]
        topic.custom_fields[TOPIC_DOCUMENT_INDEX_FIELD] = @opts[TOPIC_DOCUMENT_INDEX_FIELD]
        topic.custom_fields[TOPIC_DOCUMENT_ROUTING_FIELD] = @opts[TOPIC_DOCUMENT_ROUTING_FIELD]
        topic.custom_fields[TOPIC_DOCUMENT_TITLE_FIELD] = @opts[TOPIC_DOCUMENT_TITLE_FIELD]
        topic.custom_fields[TOPIC_DOCUMENT_CONTENT_TYPE_FIELD] = @opts[TOPIC_DOCUMENT_CONTENT_TYPE_FIELD]
        topic.custom_fields[TOPIC_DOCUMENT_URL_FIELD] = @opts[TOPIC_DOCUMENT_URL_FIELD]
        topic.save
      end
      topic
    end
  end
end