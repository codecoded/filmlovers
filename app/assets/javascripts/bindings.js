var Bindings = {

  init: function(){
    window.onpopstate = this.popstateHandler

    // $(document).pjax('a', '#container')
    $(document).on('click', 'a:not([data-no-pjax])', function(event) {
      if(ViewModel.href(event).indexOf('#')==0)
       return
      console.log('ajax request to: ' + ViewModel.href(event))
      event.preventDefault()

      RequestsController.get(ViewModel.href(event))
    })

    $(document).on('filmslist:saved',  ViewModel.filmListSaved)
    this.clickEvent('#lnkQueueListModal', ViewModel.displayQueueListModal)
    this.clickEvent('#signin-link', ViewModel.displaySignInModal)
    this.clickEvent('#fb-login', FacebookAPI.login)
  },

  setUser: function(model){
    this.ko_apply(model, 'header')
    this.clickEvent('#fb-login', FacebookAPI.login)
    this.clickEvent('#fb-logout', FacebookAPI.logout)  
  },

  setViewContent: function(model){
    this.ko_apply(model, 'viewContent')
  },

  setQueue: function(model){
    this.ko_apply(model, 'footer')
  },

  setQueueListModal: function(model){
    this.ko_apply(model, 'queueListModal')
    this.changeEvent('#queueListModal',function(e){
      ViewModel.addFilmsToList($('option:selected', $(this)).first().val())
    })
  },

  ko_apply: function(model, elementId){
    ko.applyBindings(model, document.getElementById(elementId))
  },

  ko_data: function(elementId){
    return ko.dataFor(document.getElementById(elementId))
  },

  showFilm: function(){
    $("#featured").orbit({fluid:true});
  },

  changeEvent: function(selector, eventHandler){
    $(document).on('change', selector, eventHandler)
  },

  clickEvent: function(selector, eventHandler){
    $(document).on('click', selector, eventHandler)
  },

  popstateHandler: function(event){
   if(event.state !== null)
      $.get(window.location.href, RequestsController.display)
    
  }
}
