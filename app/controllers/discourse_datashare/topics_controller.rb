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
      Topic
        .includes(:_custom_fields)
        .includes(:posts)
        .references(:_custom_fields)
        .where("topic_custom_fields.value = :entity_id", entity_id: params[:datashare_document_id])
        .first
    end

    def find_topic!
      topic = find_topic
      raise Discourse::NotFound unless topic
      topic
    end
  end
end
