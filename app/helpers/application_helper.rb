module ApplicationHelper

  def passport_link(provider, description)
    content_tag :li do 
      link_to description, "/auth/#{provider}"
    end
  end

  def awesome(icon_name, css='')
    content_tag :i, nil, :class=> %W[icon-#{icon_name} #{css}]
  end
end
