function FilmModel(data){
  var self = this
  self.id = ko.observable(data.id)
  self.title = ko.observable(data.title)
  self.release_date = ko.observable(data.release_date)
  self.director = ko.observable(data.director)
  self.url = ko.observable(data.url)
  self.thumbnail = ko.observable(data.thumbnail)
  self.full_title = self.title + "(" + self.year + ")"

  self.stats = new FilmStatsModel(data.stats)

  self.action = ko.observableArray([])
  self.actions = $.map(data.actions, function(user_action){
    return new UserFilmActionModel(self, user_action)
  })

}

