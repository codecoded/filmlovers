extends 'api/v1/shared/header'

node :categories do
  {
    films: [{title: 'Coming Soon',  url: coming_soon_api_v1_films_url}, {tile: 'In Cinemas',    url: in_cinemas_api_v1_films_url}] ,
    genres: Genre.all.map {|g| {title: g.name, url: api_v1_genre_url(g)}}
  }
end