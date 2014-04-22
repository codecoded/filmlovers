class FilmPresenter < BasePresenter
  extend Forwardable

  presents :film


  def_delegators :film, :title, :has_poster?, :id, :has_backdrop?, :has_trailer?, :year, :director

  def counts
    @counts ||= FilmEntry.counts_for_film(film.id)
  end

  def film_entry
    film.entries.first || current_user.film_entries.new(film_id: film.id)
  end

  def release_date
    film.release_date.strftime('%d %B %Y') if film.release_date
  end

  def classification
    film.classification
  end

  def trailer
    "http://www.youtube.com/embed/#{film.trailer}?iv_load_policy=3&modestbranding=1&origin=localhost&rel=0&showinfo=0&controls=1"
  end

  def iframe_for(trailer)
    content_tag :iframe, nil, src: trailer, frameborder: 0, allowfullscreen: true, itemprop: 'embedUrl'
  end

  def blank_poster
    image_tag "placeholder.jpg", :title=>film.title, alt: "poster for #{film.title}"
  end

  def poster_sizes
    @poster_sizes  ||= {small: 'w90', medium: 'w185', large: 'w342', original: 'original'}
  end

  def backdrop_sizes
    @backdrop_sizes  ||= {small: 'w300', medium: 'w780', large: 'w1280', original: 'original'}
  end

  def poster_uri(size=:medium)
    return film.poster if (film.poster =~ /http/)
    AppConfig.image_uri_for [poster_sizes[size], film.poster] if film.poster?
  end

  def poster
    return blank_poster unless film.poster?
    image_src = case film.provider.to_sym.downcase
      when :tmdb then poster_uri
      else film.poster
    end

    image_tag image_src, :title=>film.title, alt: "poster for #{film.title}", itemprop: 'thumbnailUrl'
  end

  def backdrop_uri(size=:original)
    return film.backdrop if (film.backdrop =~ /http/)
    AppConfig.image_uri_for [backdrop_sizes[size], film.backdrop] if film.backdrop?
  end

  def poster_link
    link_to poster, film_path(film), title: film.title
  end


  def providers
    @providers ||= film.providers.to_a
  end

  def provider_links
    providers.map do |p|
      {
        id: p.id,
        name: p.name,
        link: p.link,
        rating: p.rating
      }
    end
  end

  def apple_link(storefront_id=143444)
    apple_provider = providers.find {|p| p.name == 'apple' and p.storefront_ids and p.storefront_ids.include?(storefront_id.to_s)}
    return {} unless apple_provider.storefront_ids.include?(storefront_id.to_s) 
    {
      id: apple_provider.id,
      name: apple_provider.name,
      link: apple_provider.aff_link,
      rating: apple_provider.rating
    }  
  end

  def apple_affiliate_link(storefront_id=143444)
    itunes_url = "http://ax.itunes.apple.com/WebObjects/MZSearch.woa/wa/search?media=movie&country=GB&term=#{film.title}"
    apple_provider = providers.find {|p| p.name == 'apple' and p.storefront_ids and p.storefront_ids.include?(storefront_id.to_s)}
    apple_provider ?  apple_provider.aff_link :  "http://clkuk.tradedoubler.com/click?p=23708&a=2247239&g=19223668&url=#{itunes_url}&partnerId=2003"   
  end

  def find_provider(name)
    providers.find {|p| p.name.downcase==name.to_s.downcase}
  end

  def other_links
    return if providers.empty?

    other = ''

    if tmdb = find_provider(:tmdb)
      other = content_tag :a,  href: tmdb.link,  alt:"TMDB link for #{film.title}", target: '_blank' do 
        image_tag 'tmdb_logo.png', width: "80px"
      end
    end

    if imdb = find_provider(:imdb)
      other += content_tag :a,  href: "http://www.imdb.com/title/#{imdb.reference}",  alt:"IMDB link for #{film.title}", target: '_blank' do 
        image_tag 'imdb_logo.png'
      end
    end

    if netflix = find_provider(:netflix)
      other += content_tag(:a,  href: netflix.link,  alt:"Netflix link for #{film.title}", target: '_blank') do 
         image_tag('netflix-n-logo.png') << "#{netflix.rating}<font style='font-size:60%'>/5</font>".html_safe
      end
    end

    if rotten = find_provider(:rotten)
      other += content_tag(:a,  href: rotten.link,  alt:"RottenTomatoes link for #{film.title}", target: '_blank') do 
         image_tag('rotten.png') << "#{rotten.rating}".html_safe
      end
    end

    other 
  end

end