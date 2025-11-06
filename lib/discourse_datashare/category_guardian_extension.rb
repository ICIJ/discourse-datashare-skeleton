# frozen_string_literal: true

module DiscourseDatashare
  module CategoryGuardianExtension    
    def can_create_category?(parent = nil)
      super(parent) || @user.in_any_groups?(SiteSetting.datashare_create_category_groups_map)
    end
  end
end