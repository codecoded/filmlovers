object false

if !locals[:hide_header]
  extends 'api/v1/shared/header'
end

presenter = present(person, PersonPresenter)

node :person do
  {
    id: presenter.id,
    name: presenter.name,
    biography: presenter.biography,
    place_of_birth: presenter.place_of_birth,
    birthday: presenter.dob,
    profile_path: presenter.profile('w342'),
    starred_in: presenter.films_starred_in.map do |roles|
      {
        character: roles[:character],
        id: roles[:film_presenter].id,
        title: roles[:film_presenter].title,
        poster: roles[:film_presenter].poster_uri
      }
    end,
    worked_on: presenter.films_worked_on.map do |roles|
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

