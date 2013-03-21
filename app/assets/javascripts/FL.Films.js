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
    $(document).on('click', 'i[data-action]', FL.Films.iconFilmActionClicked)
    $(document).on('click', '#signin-link', ViewModel.displaySignInModal)
  },

  displayContent: function(xhr, data, status){
    $('#container').html(data)
  },

  endlessScroll: function(){
    self = this
    loading = false
    threshold = 300

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
            loading = false
            
            if(!html)
              return $('div#loadmoreajaxloader').html('<center>No more posts to show.</center>');
        
            $('#filmsLinkNext').remove()
            $("#filmsContent").append($(html).find('.film'))
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
        button.data('method', (to_action ? 'delete' : 'put'))
        button.find('i').toggleClass('actioned unactioned')  
        // if(action=='watched')
        //   button.parents('.film').toggleClass('watched')
      }  
    })
  },

  iconFilmActionClicked: function(event){
    icon = $(this)
    
    href = icon.data('href')
    method = icon.data('method')
    to_action = method == 'put'
    incr = to_action ? 1 : -1
    action = icon.data('action')
    $.ajax({
      url: href,
      type: method,
      dataType: 'json',
      success: function(xhr, data, status){
        icon.data('method', (to_action ? 'delete' : 'put'))
        icon.toggleClass('actioned unactioned') 
        if(action=='queued')
          return
        
        counter = icon.prev('label')
        counter.text(parseInt(counter.text()) + incr)
        
      }  
    })
  }
}