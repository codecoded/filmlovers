function FilmsQueueModel(data){
  self = this
  self.films = ko.observableArray(FilmModel.arrayFromJSON(data))


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

    event.preventDefault()
    var href = $(event.target).attr('href')
    // var ids = self.selectedIds()
    // var newHref = href + '?' + $.param({'film_ids': ids})
    console.log(href)
    RequestsController.get(href + '?' + $.param({'film_ids': self.selectedIds()}))
    // $(event.target).attr('href', newHref)
  }

  self.selectedIds = function(){
    return self.selected().map(function(film){return film.id()})
  }

  self.addToList = function(view,event){
    var href = $('option:selected', $(event.target)).first().val()
    RequestsController.get(href + '?' + $.param({'film_ids': self.selectedIds()}))
  }

}
