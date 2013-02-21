function FilmModel(data){
  var self = this
  self.id = ko.observable(data.id)
  self.title = ko.observable(data.title)
  self.release_date = ko.observable(data.release_date)
  self.director = ko.observable(data.director)
  self.url = ko.observable(data.url)
  self.thumbnail = ko.observable(data.thumbnail)
  self.full_title = self.title + "(" + self.year + ")"
  self.selected = ko.observable(false)

  self.stats = new FilmStatsModel(data.stats)

  self.actions = ko.observableArray([])
  if(data.actions)
    self.actions = $.map(data.actions, function(user_action){ return new UserFilmActionModel(self, user_action) })

  self.select = function(){ self.selected(!self.selected())}
}


FilmModel.arrayFromJSON = function(json){
  if(!json)
    return new Array()
  return $.map(json, function (film) {return new FilmModel(film) })
}

FilmModel.arrayToJSON = function(films){
  if(!films)
    return new Array()
  return $.map(films, function (film) {return film.id() })
}