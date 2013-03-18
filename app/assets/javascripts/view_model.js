var ViewModel = {
  user: null,
  queue: null,
  friendsList: null,
  filmsPage: ko.observable(),

  init: function(){
    ViewModel.loadUser(ViewModel.loadQueue)
    Bindings.init()
    FacebookAPI.init()
  },

  loadUser: function(callback){
    $.getJSON('/current_user', function(data){
      ViewModel.user = new UserModel(data)
      Bindings.setUser(ViewModel.user)
      // if(callback) callback()
    })
  },

  loadQueue: function(){
    console.log('loading queue for ' + ViewModel.user.username)
    $.getJSON('/' + ViewModel.user.username + '/queue/show.json/', function(json) { 
      ViewModel.queue = new FilmsQueueModel(json)
      Bindings.setQueue(ViewModel.queue)
      Queue.init()
    })
  },

  loadFriends: function(){
    FacebookAPI.friends(function(response) {
      friends = $.map(response, function(friend){ return new FBFriendModel(friend) })

      ViewModel.friendsList = new FriendsList(friends)
      $(document).trigger('friends:loaded')
    })
  },

  displayQueueListModal: function(e){
    e.preventDefault()

    $.get($(this).attr('href'), function(data, status){
      ModalController.queue_modal(data)
      Bindings.setQueueListModal(ViewModel.queue)
    })
  },

  displaySignInModal: function(e){
    e.preventDefault()
    console.log('tes')
    $.get($(this).attr('href'), function(data, status){
      ModalController.queue_modal(data)
    })
  },

  addFilmsToList: function(list_url){
    $.ajax({
      url: list_url,
      type: 'put',
      data: {film_ids: ViewModel.queue.selectedIds()},
      dataType: 'json',
      success: function(response){
        ViewModel.queue.dequeueSelected()
        ModalController.close_modal()
      }  
    })

  },

  filmListSuccess: function(event, filmList, response){
    console.log(filmList)
    RequestsController.get(filmList.lists_url)
  },


  loadFilmsPage: function(filmModel, event){
    event.preventDefault()
    event.stopPropagation()
    history.pushState(null, null, ViewModel.href(event,'.json'))
    $.getJSON(ViewModel.href(event), function(data){      
      filmModel.update(new FilmsPageModel(data))
    })
  },

  showFilm: function(filmURI){
    RequestsController.get(filmURI)
    Bindings.showFilm()
  },

  href: function(target, removeString){
    href = $(target.currentTarget).attr('href') || ''
    return href.replace(removeString, '')
  }
}

$(function(){
  ViewModel.init()
})
