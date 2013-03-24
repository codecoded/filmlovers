module ApplicationHelper

  def passport_link(provider, description)
    content_tag :li do 
      link_to description, "/auth/#{provider}"
    end
  end
end
