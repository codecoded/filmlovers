var ViewModel = {
  user: null,
  queue: null,
  filmsPage: ko.observable(),

  init: function(){
    ViewModel.loadUser(ViewModel.loadQueue)
  },

  loadUser: function(callback){
    $.getJSON('/current_user', function(data){
      ViewModel.user = new UserModel(data)
      Bindings.setUser(ViewModel.user)
      if(callback) callback()
    })
  },

  loadQueue: function(){
    $.getJSON(ViewModel.user.username() + '/queue/show.json/', function(json) { 
      ViewModel.queue = new FilmsQueueModel(json)
      Bindings.setQueue(ViewModel.queue)
      Queue.init()
    })
  },

  displayQueueListModal: function(e){
    e.preventDefault()
    $.get($(this).attr('href'), function(data, status){
      ModalController.queue_modal(data)
      Bindings.setQueueListModal(ViewModel.queue)
    })
  },

  addFilmsToList: function(list_url){
    RequestsController.get(list_url + '?' + $.param({'film_ids': ViewModel.queue.selectedIds()}))
    ModalController.close_modal()
  },

  filmListSaved: function(filmList, response){
    RequestsController.get(filmList.parent_url)
  },

  loadFilmsPage: function(filmModel, event){
     event.preventDefault()
    $.getJSON(ViewModel.href(event), function(data){
      filmModel.update(new FilmsPageModel(data))
    })
  },

  href: function(target){
    return $(target.currentTarget).attr('href')
  }
}