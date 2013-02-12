function FilmStatsModel(data){
  var self = this

  self.watched = ko.observable(data ? data.watched : 0)
  self.loved = ko.observable(data ? data.loved : 0)
  self.owned = ko.observable(data ? data.owned : 0)
  self.queued = ko.observable(data ? data.queued : 0)
}

