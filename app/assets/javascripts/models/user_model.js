function UserModel(){

  var self = this

  self.name  = ko.observable(0)

  self.filmStats = new FilmStatsModel()
  self.loggedIn = ko.observable(false)
  self.loggedOut = ko.observable(false)

  self.update_from_json = function(json){
    self.name(json.name)
  }
  self.load = function(){
    $.get('/current_user.json', function(json){
      self.update_from_json(json)
    })
  }
}

