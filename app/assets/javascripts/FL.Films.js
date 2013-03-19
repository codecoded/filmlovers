FL = {}
FL.Films = {}

FL.Films = {
  init: function(){
    FL.Films.initListeners()
  },

  endlessScroll: function(){
    self = this
    loading = false
    threshold = 400

    $(window).scroll(function()
    {
      currentPos = $(window).scrollTop() + threshold 
      totalHeight = $(document).height() - $(window).height()
      if(currentPos >= totalHeight && !loading)
      {
        loading = true
        next = $('#filmsLinkNext').attr('href')
        if(!next) return
        $.ajax({
          url: next,
          success: function(html){
            console.log('loaded')
            loading = false
            
            if(!html)
              return $('div#loadmoreajaxloader').html('<center>No more posts to show.</center>');
        
            $('#filmsLinkNext').remove()
            $("#filmsContent .films").append($(html).find('.film'))
            $("#filmsContent").append($(html).find('#filmsLinkNext'))
          } 
        })
      }
    })
  },

  initListeners: function(){
    $(document).on('click', 'button.film-action', FL.Films.btnFilmActionClicked)
  },

  btnFilmActionClicked: function(event){
    button = $(this)
    
    href = button.data('href')
    method = button.data('method')
    to_action = method == 'put'
    incr = to_action ? 1 : -1
    action = button.attr('name')
    $.ajax({
      url: href,
      type: method,
      dataType: 'json',
      success: function(data, xhr, s){
        ViewModel.user.updateStat(action, incr)
        button.data('method', (to_action ? 'delete' : 'put'))
        button.find('i').toggleClass('actioned unactioned')
        console.log('film updated')
        // if(action=='queued'){
        //   // self.isActioned() ? ViewModel.queue.queueFilm(self.film) : ViewModel.queue.dequeueFilm(self.film)
        // }
        // else
        // {
        //   self.film.stats.updateStat(self.name(), statIncr)
        // }
        // return self.count(data.count)    
      }  
    })
  }
}