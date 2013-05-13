module ApplicationHelper

  def passport_link(provider, description)
    content_tag :li do 
      link_to description, "/auth/#{provider}", alt: "sign in to filmlovers using #{description}"
    end
  end

  def awesome(icon_name, css='')
    content_tag :i, nil, :class=> %W[icon-#{icon_name} #{css}]
  end

  def shorten(text, truncate_at=180)
     truncate text, separator: ' ', length: truncate_at, :omission => '...'
  end

  def avatar(user, size='normal')
    if user.passport_provider? :facebook
      image_tag user.channels[:facebook].facebook.avatar, :class=>"avatar #{size}"
    else
      image_tag user.gravatar_url, :class=>"avatar #{size}"
    end
  end
end
