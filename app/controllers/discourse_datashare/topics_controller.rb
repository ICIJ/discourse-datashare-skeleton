# frozen_string_literal: true

module DiscourseDatashare
  class TopicsController < ::ApplicationController
    requires_plugin PLUGIN_NAME
    before_action :ensure_logged_in

    def show
      topic = find_topic!

      params[:page] = params[:page].to_i rescue 1 if params.key?(:page)
      params[:limit] = params[:limit].to_i rescue 20 if params.key?(:limit)      
      opts = params.slice(:page, :limit, :post_number)
      
      render_serialized(TopicView.new(topic, current_user, opts), TopicViewPostsSerializer)
    end

    def posts
      topic = find_topic

      if topic.present?
        render json: { posts_count: topic.posts_count }
      else
        render json:  { posts_count: 0 }
      end
    end

    private

    def find_topic
      # Required document ID (custom field name and value)
      name  = "datashare_document_id"
      value = params.require(:datashare_document_id)
      # Optional document index for disambiguation
      index = params[:datashare_document_index].presence

      # Find all topics that have a custom field
      scope = Topic
        .joins(:_custom_fields)
        .where(topic_custom_fields: { name: name, value: value })
      # For retro compatibility, we support filtering by index on if an index
      # is given. We want to find:
      #   * Topics with no 'datashare_document_index' custom field
      #   * OR topics whose index matches the given value
      if index
        scope = scope
          .joins(
            "LEFT JOIN topic_custom_fields AS tcf
              ON tcf.topic_id = topics.id
              AND tcf.name = 'datashare_document_index'"
          )
          .where("tcf.value IS NULL OR tcf.value = ?", index)
      end

      # Get the first matching topic, including posts and custom fields
      topic = scope.includes(:posts, :_custom_fields).distinct.first
      # Finally, ensure the user can see the topic
      @guardian.can_see_topic?(topic) ? topic : nil
    end

    def find_topic!
      topic = find_topic
      raise Discourse::NotFound unless topic
      topic
    end
  end
end
