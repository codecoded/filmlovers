module ApplicationHelper

  def passport_link(provider, description)
    content_tag :li do 
      link_to description, "/auth/#{provider}"
    end
  end

  def awesome(icon_name, css='')
    content_tag :i, nil, :class=> %W[icon-#{icon_name} #{css}]
  end

  def shorten(text, truncate_at=180)
     truncate text, separator: ' ', length: truncate_at, :omission => '...'
  end
end
