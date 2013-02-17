function FilmsCollection(data){
  var self = this

  self.films = ko.observableArray(FilmModel.arrayFromJSON(data))

  self.add   = function(film_to_add, callback){ 
    self.films.unshift(film_to_add)
    if(callback) callback() 
  }

  self.remove = function(film_to_remove, callback){
    self.films.remove(function(film){ return film_to_remove.id() == film.id()  })
    if(callback) callback() 
  }

  self.selected = function(){
    return $.grep(self.films(), function(item, index){ return item.selected()})
  }

}