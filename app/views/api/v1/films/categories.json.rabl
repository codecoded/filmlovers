extends 'api/v1/shared/header'

node :categories do
  {
    films: [{title: 'Coming Soon',  url: category_api_v1_films_url('coming_soon')}, {tile: 'In Cinemas',    url: category_api_v1_films_url(action: 'in_cinemas')}] ,
    genres: Genre.all.map {|g| {title: g.name, url: category_api_v1_films_url(genres: g)}}
  }
end