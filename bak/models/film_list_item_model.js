function FilmListItemModel(data){
  var self = this
  self.film = new FilmModel(data.film)
  self.position = ko.observable(data.position)
  self.id = self.film.id()
}


FilmListItemModel.arrayFromJSON = function(json){
  if(!json)
    return new Array()
  return $.map(json, function (film) {return new FilmListItemModel(film) })
}

FilmListItemModel.arrayToJSON = function(film_list_items){
  if(!film_list_items)
    return new Array()
  return $.map(film_list_items, function (film_list_item) { 
    return { 
        'film_id': film_list_item.film.id, 
        'position': film_list_item.position() 
      }
  })
}