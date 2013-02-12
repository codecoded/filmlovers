function FilmsQueueModel(films){
  self = this
  self.films = ko.observableArray(films)

  self.queueFilm   = function(film_to_add){ 
    self.films.unshift(film_to_add)
    Queue.init()
  }
  self.dequeueFilm = function(film_to_remove){
    self.films.remove(function(film){ return film_to_remove.id() == film.id()  })
    Queue.init()
  }


}

FilmsQueueModel.load = function(user, container) {
  $.getJSON(user.username() + '/queue/show.json/', function(json) { 
    films = $.map(json, function (film) {return new FilmModel(film) })
    viewModel.queue = new FilmsQueueModel(films)
    ko.applyBindings(viewModel.queue, container)
    Queue.init()
  })
}