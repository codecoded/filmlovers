object false


node(:header) do 
  {
    title: "Films Search",
    num: 1,
    limit: @results.count
  }
end

node(:data) do
  @results.map do |film|
    {
      primary: film.title,
      secondary: film.uk_release_date,
      image: (film.poster('w45') if film.has_poster?)
    }
  end
end
