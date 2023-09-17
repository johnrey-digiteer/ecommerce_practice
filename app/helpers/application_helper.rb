module ApplicationHelper
    def devise_mapping
        @devise_mapping ||= Devise.mappings[:user]
    end

    def resource_name
        devise_mapping.name
    end
end
