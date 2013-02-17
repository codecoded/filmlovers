function FilmsQueueModel(data){
  self = this
  self.films = ko.observableArray(FilmModel.arrayFromJSON(data))

  self.listsUrl = data.listsUrl

  self.queueFilm   = function(film_to_add){ 
    self.films.unshift(film_to_add)
    Queue.init()
  }
  self.dequeueFilm = function(film_to_remove){
    self.films.remove(function(film){ return film_to_remove.id() == film.id()  })
    Queue.init()
  }

  self.selected = function(){
    return $.grep(self.films(), function(item, index){ return item.selected()})
  }

  self.listsUrl = function(model, event){
    var href = $(event.target).attr('href')
    var ids = self.selected().map(function(film){return film.id()})

    var newHref = href + '?' + $.param({'film_ids': ids})

    $(event.target).attr('href', newHref)
  }

}

FilmsQueueModel.load = function(user, container) {
  $.getJSON(user.username() + '/queue/show.json/', function(json) { 
    console.log(json)
    viewModel.queue = new FilmsQueueModel(json)
    ko.applyBindings(viewModel.queue, container)
    Queue.init()
  })
}