var ModelsHelper = {

  FilmsPageModel: function(uri) {
   $.getJSON(uri, function(films_data) { 
      model = new FilmsModel()
      model.load(films_data)
      return model
    })
  },

  FilmsQueueModel: function(user){
    $.getJSON(user + '/queued', function(films_data) { 
      model = new FilmsQueueModel(user, data)
      model.load(films_data)
      return model
    })
  }

}