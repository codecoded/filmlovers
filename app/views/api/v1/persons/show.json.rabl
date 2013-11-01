object @presenter

if !locals[:hide_header]
  extends 'api/v1/shared/header'
end

node :person do |person|
  {
    id: person.id,
    name: person.name,
    biography: person.biography,
    place_of_birth: person.place_of_birth,
    birthday: person.dob,
    profile_path: person.profile('w342'),
    starred_in: person.films_starred_in.map do |roles|
      {
        character: roles[:character],
        id: roles[:film_presenter].id,
        title: roles[:film_presenter].title,
        poster: roles[:film_presenter].poster_uri
      }
    end,
    worked_on: person.films_worked_on.map do |roles|
      {
        department: roles[:department],
        job: roles[:job],
        id: roles[:film_presenter].id,
        title: roles[:film_presenter].title,
        poster: roles[:film_presenter].poster_uri
      }
    end
  }
end

