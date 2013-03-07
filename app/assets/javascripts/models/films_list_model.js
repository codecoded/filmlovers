function FilmsListModel(data){
  var self = this

  self.id = data.id
  self.name = ko.observable(data.name)
  self.description = ko.observable(data.description)
  self.lists_url = data.lists_url
  self.url = data.url
  self.edit_url = data.edit_url
  
  self.films = ko.observableArray(FilmListItemModel.arrayFromJSON(data.film_list_items))

  self.films.sort(function(film1, film2){
    return film1.position() == film2.position() ? 0 : (film1.position() < film2.position() ? -1 : 1)
  })

  self.fetch = function(film_id){
    $.getJSON('/films/' + film_id, function(data){
      self.addFilmItem(new FilmListItemModel({'position':1, 'film': data}))
    })
  }

  self.addFilmItem   = function(film_to_add){ 
    self.films.unshift(film_to_add)
  }

  self.removeFilmItem = function(film_to_remove){
    self.films.remove(function(film){ return film_to_remove.id == film.id  })
  }

  self.find = function(film_id){
    return $.grep(self.films(), function(item, index){ return item.id == film_id})[0]
  },

  self.selected = function(){
    return $.grep(self.films(), function(item, index){ return item.selected()})
  }

  self.dataMethod = function(){
    return self.id ? 'put' : 'post'
  }

  self.toJSON = function(){
    return {
      'films_list':{
        '_id': self.id,
        'name': self.name(),
        'description': self.description(),
        'film_list_items': FilmListItemModel.arrayToJSON(self.films())
      }
    }
  }

  self.save = function(){
    $.ajax({
      url: self.url,
      type: self.dataMethod(),
      data: self.toJSON(),
      dataType: 'json',
      success: function(response){
        ViewModel.filmListSuccess(self, response)
      }  
    })
  }

  self.remove = function() {
    console.log(self.url)
    $.ajax({
      url: self.url,
      type: 'delete',
      data: {},
      dataType: 'json',
      success: function(response){
        ViewModel.filmListSuccess(self, response)
      }  
    })
  }

}

FilmsListModel.load = function(uri){
  $.get(uri, function(data){
  })
}

FilmsListModel.arrayFromJSON = function(json){
  if(!json)
    return new Array()
  return $.map(json, function (film) {return new FilmsListModel(film) })
}

function ListsModel(data){

  var self = this
  self.lists = ko.observableArray(FilmsListModel.arrayFromJSON(data))
  self.add   = function(list){ 
    self.lists.unshift(list)
  }

  self.remove = function(list){
    self.lists.remove(function(item){ return list.id() == item.id()  })
  }

  self.selected = function(){
    return $.grep(self.lists(), function(item, index){ return item.selected()})
  }
}


