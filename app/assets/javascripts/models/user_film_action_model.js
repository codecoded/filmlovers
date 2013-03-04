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
      success: function(data, xhr, s){
        self.isActioned(!self.isActioned())
        statIncr = self.isActioned() ? 1 : -1
        ViewModel.user.updateStat(self.name(), statIncr)

        if(self.isQueueAction()){
          self.isActioned() ? ViewModel.queue.queueFilm(self.film) : ViewModel.queue.dequeueFilm(self.film)
        }
        else
        {
          self.film.stats.updateStat(self.name(), statIncr)
        }
        return self.count(data.count)    
      }  
    })
  }

}