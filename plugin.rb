# frozen_string_literal: true

# name: discourse-datashare
# about: A plugin to integrate Discourse with Datashare.
# authors: ICIJ <engineering@icij.org>
# url: https://github.com/ICIJ/discourse-datashare
# required_version: 3.4.0


enabled_site_setting :datashare_enabled

register_asset 'stylesheets/common/index.scss'

module ::DiscourseDatashare  
  PLUGIN_NAME = 'discourse-datashare'.freeze
end

require_relative 'lib/engine'

after_initialize do
  Discourse::Application.routes.append do
    mount ::DiscourseDatashare::Engine, at: "/datashare"
    mount ::DiscourseDatashare::Engine, at: "/custom-fields-api", as: 'discourse_datashare_legacy'
    # For backward compatibility we add a endpoint to list a group's categories. The GroupsController is
    # monkey patched to handle this action through the GroupsControllerExtension class.
    get '/g/:name/categories' => 'groups#categories'
  end

  reloadable_patch do
    Category.prepend ::DiscourseDatashare::CategoryExtension
    CategoriesController.prepend ::DiscourseDatashare::CategoriesControllerExtension
    CategoryGuardian.prepend ::DiscourseDatashare::CategoryGuardianExtension
    GroupsController.prepend ::DiscourseDatashare::GroupsControllerExtension
    TopicCreator.prepend ::DiscourseDatashare::TopicCreatorExtension
  end

  # Register additional icons, including multiple supported file types
  register_svg_icon "arrow-up-right-from-square"
  register_svg_icon "file-pdf"
  register_svg_icon "file-word"
  register_svg_icon "file-excel"
  register_svg_icon "file-powerpoint"
  register_svg_icon "file-image"
  register_svg_icon "file-audio"
  register_svg_icon "file-zipper"
  register_svg_icon "file-video"

  # Register custom fields to associate a Datashare's document with a topic
  Topic.register_custom_field_type(::DiscourseDatashare::TOPIC_DOCUMENT_ID_FIELD, :string)
  Topic.register_custom_field_type(::DiscourseDatashare::TOPIC_DOCUMENT_INDEX_FIELD, :string)
  Topic.register_custom_field_type(::DiscourseDatashare::TOPIC_DOCUMENT_ROUTING_FIELD, :string)
  Topic.register_custom_field_type(::DiscourseDatashare::TOPIC_DOCUMENT_TITLE_FIELD, :string)
  Topic.register_custom_field_type(::DiscourseDatashare::TOPIC_DOCUMENT_CONTENT_TYPE_FIELD, :string)
  Topic.register_custom_field_type(::DiscourseDatashare::TOPIC_DOCUMENT_URL_FIELD, :string)
  # This allows custom fields to be set through the API when creating a topic
  add_permitted_post_create_param(::DiscourseDatashare::TOPIC_DOCUMENT_ID_FIELD, :string)
  add_permitted_post_create_param(::DiscourseDatashare::TOPIC_DOCUMENT_INDEX_FIELD, :string)
  add_permitted_post_create_param(::DiscourseDatashare::TOPIC_DOCUMENT_ROUTING_FIELD, :string)
  add_permitted_post_create_param(::DiscourseDatashare::TOPIC_DOCUMENT_TITLE_FIELD, :string)
  add_permitted_post_create_param(::DiscourseDatashare::TOPIC_DOCUMENT_CONTENT_TYPE_FIELD, :string)
  add_permitted_post_create_param(::DiscourseDatashare::TOPIC_DOCUMENT_URL_FIELD, :string)
  
  # Register a custom field to flag categories created by this plugin
  Category.register_custom_field_type(::DiscourseDatashare::CATEGORY_CREATED_BY_FIELD, :boolean)
  # This is necessary to avoid NotPreloadedError when accessing the custom field
  # through the category serializer defined below.
  register_preloaded_category_custom_fields(::DiscourseDatashare::CATEGORY_CREATED_BY_FIELD)

  add_to_serializer(
    :basic_category, 
    :created_by_dataconnect,
    # This condition ensures that the custom field is not included 
    # in the CategoryListSerializer (which already includes custom fields).
    include_condition: -> { !self.instance_of? CategoryListSerializer  }) do
    !!object.custom_fields[::DiscourseDatashare::CATEGORY_CREATED_BY_FIELD]
  end

  add_to_serializer(:topic_view, :datashare_document) do
    { 
      id: object.topic.custom_fields[::DiscourseDatashare::TOPIC_DOCUMENT_ID_FIELD],
      index: object.topic.custom_fields[::DiscourseDatashare::TOPIC_DOCUMENT_INDEX_FIELD],
      routing: object.topic.custom_fields[::DiscourseDatashare::TOPIC_DOCUMENT_ROUTING_FIELD],
      title: object.topic.custom_fields[::DiscourseDatashare::TOPIC_DOCUMENT_TITLE_FIELD],
      contentType: object.topic.custom_fields[::DiscourseDatashare::TOPIC_DOCUMENT_CONTENT_TYPE_FIELD],
      url: object.topic.custom_fields[::DiscourseDatashare::TOPIC_DOCUMENT_URL_FIELD]
    }
  end

  add_to_serializer(:post, :full_url) do
    object.full_url
  end

  add_to_serializer(:current_user, :can_create_category) do
    Guardian.new(scope.user).can_create_category?
  end
end
