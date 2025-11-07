# frozen_string_literal: true
require 'rails_helper'

describe TopicCreator do
  fab!(:admin)

  let(:valid_attrs) { Fabricate.attributes_for(:topic) }

  describe '#create' do
    context 'with successful topic creation' do
      before do
        TopicCreator.any_instance.expects(:save_topic).returns(true)
        TopicCreator.any_instance.expects(:watch_topic).returns(true)
        SiteSetting.allow_duplicate_topic_titles = true
      end

      it "supports datashare_document_id only in custom_fields" do
        custom_fields = { datashare_document_id: "1234" }
        opts = valid_attrs.merge(custom_fields:)

        topic = TopicCreator.create(admin, Guardian.new(admin), opts)

        expect(topic.custom_fields["datashare_document_id"]).to eq("1234")
        expect(topic.custom_fields["datashare_document_index"]).to eq(nil)
        expect(topic.custom_fields["datashare_document_routing"]).to eq(nil)
        expect(topic.custom_fields["datashare_document_title"]).to eq(nil)
      end

      it "supports all datashare custom_fields" do
        custom_fields = { 
          datashare_document_id: "1234", 
          datashare_document_index: "banana-papers", 
          datashare_document_routing: "5678",
          datashare_document_title: "My Document"
        }
        opts = valid_attrs.merge(custom_fields:)

        topic = TopicCreator.create(admin, Guardian.new(admin), opts)

        expect(topic.custom_fields["datashare_document_id"]).to eq("1234")
        expect(topic.custom_fields["datashare_document_index"]).to eq("banana-papers")
        expect(topic.custom_fields["datashare_document_routing"]).to eq("5678")
        expect(topic.custom_fields["datashare_document_title"]).to eq("My Document")
      end
    end
  end
end
