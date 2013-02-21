function UserFilmActionModel(film, data){
  var self = this
  self.film = film
  self.name = ko.observable(data.name)
  self.count = ko.observable(data.count)
  self.isActioned = ko.observable(data.isActioned)
  self.url = ko.observable(data.url)

  self.dataMethod = function(){
    return self.isActioned() ? 'delete' : 'put'
  }

  self.isQueueAction = function(){ return self.name() === 'queued' }

  self.icon = ko.computed(function(){
    switch(self.name()){
      case 'watched':
        return 'icon-eye-open'
      case 'loved':
        return 'icon-heart'
      case 'owned':
        return 'icon-home'
      case 'queued':
        return 'icon-pushpin'
    }
  })

  self.actionCSS = ko.computed(function(){
    return self.icon() + (self.isActioned() ? ' actioned' : ' unactioned')
  })

  self.action = function(){
    $.ajax({
      url: self.url(),
      type: self.dataMethod(),
      dataType: 'json',
      success: function(data){
        self.isActioned(!self.isActioned())
        ViewModel.user.updateStat(self.name(), self.isActioned() ? 1 : -1)

        if(self.isQueueAction()){
          self.isActioned() ? ViewModel.queue.queueFilm(self.film) : ViewModel.queue.dequeueFilm(self.film)
        }

        return self.count(data.count)    
      }  
    })
  }

}