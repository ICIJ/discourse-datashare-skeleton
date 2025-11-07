# frozen_string_literal: true

module DiscourseDatashare
  # Extends the Category model to add a scope for categories
  # created by dataconnect (through the custom fields API).
  module CategoryExtension
    extend ActiveSupport::Concern

    prepended do
      scope :created_by_dataconnect, -> {
        where(id: 
          CategoryCustomField
            .where(name: CATEGORY_CREATED_BY_FIELD, value: 'true')
            .select(:category_id)
        )
      }
    end  
  end
end