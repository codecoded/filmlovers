function FilmsListModel(data){
  var self = this

  self.id = data.id
  self.name = ko.observable(data.name)
  self.description = ko.observable(data.description)
  self.url = data.parent_url
  self.url = data.url

  self.films = ko.observableArray(FilmModel.arrayFromJSON(data.films))

  self.add   = function(film_to_add){ 
    self.films.unshift(film_to_add)
  }

  self.remove = function(film_to_remove){
    self.films.remove(function(film){ return film_to_remove.id() == film.id()  })
  }

  self.selected = function(){
    return $.grep(self.films(), function(item, index){ return item.selected()})
  }

  self.dataMethod = function(){
    return self.id ? 'put' : 'post'
  }

  self.toJSON = function(){
    return {
      '_method': self.dataMethod,
      'films_list':{
        'name': self.name,
        'description': self.description
      }
    }
  }

  // self.save = function(){
  //   console.log('save caleld')
  //   $.ajax({
  //     url: self.url,
  //     type: self.dataMethod(),
  //     data: self.toJSON(),
  //     dataType: 'json',
  //     success: function(data){
  //       RequestsController.display(data)
  //     }  
  //   })
  // }
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