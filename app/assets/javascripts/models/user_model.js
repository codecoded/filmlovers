function UserModel(data){
  var self = this

  self.loggedIn = ko.observable(false)
  self.loggedOut = ko.observable(false)
  
  self.filmStats = new FilmStatsModel(data.stats)

  if(!data) return

  self.name  = data.name
  self.username = data.username

  self.actionFilm = function(film, action){
    film.registerAction(action)
    self.incrementStat(action)
  }

  self.updateStat = function(action_name, value){
    stat = self.filmStats[action_name]
    stat(stat() + value)    
  }
}
