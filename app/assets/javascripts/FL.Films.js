FL = {}
FL.Films = {}

FL.Films = {
  initialised: false,

  init: function(){
    
    if(FL.Films.initialised) return

    FL.Films.initListeners()
    FL.Films.initialised = true
  },

  initListeners: function(){
    $(document).on('ajax:success', 'a', FL.Films.displayContent)
    $(document).on('click', 'button.film-action', FL.Films.btnFilmActionClicked)
    console.log('listeners initialised')
  },

  displayContent: function(xhr, data, status){
    $('#container').html(data)
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
      success: function(xhr, data, status){
        ViewModel.user.updateStat(action, incr)
        button.data('method', (to_action ? 'delete' : 'put'))
        button.find('i').toggleClass('actioned unactioned')   
      }  
    })
  }
}