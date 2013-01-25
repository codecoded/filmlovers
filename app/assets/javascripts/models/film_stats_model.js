function FilmStatsModel(){
  var self = this
  self.watched = ko.observable(0)
  self.loved = ko.observable(0)
  self.unloved = ko.observable(0)
  self.owned = ko.observable(0)
}
