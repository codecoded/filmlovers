FL = {}
FL.Films = {}

FL.Films = {
  initialised: false,

  init: function(){
    
    if(FL.Films.initialised) return

    FL.Films.initListeners()
    FL.Films.endlessScroll()
    FL.Films.initialised = true
  },

  initListeners: function(){
    $(document).on('ajax:success', 'a', FL.Films.displayContent)
    $(document).on('click', 'button.film-action', FL.Films.btnFilmActionClicked)
    $(document).on('click', 'i[data-action]', FL.Films.iconFilmActionClicked)
    $(document).on('click', '#signin-link, a.display-modal', FL.Films.displayModal)
    $(document).on('change', '#sort-option', FL.Films.sortUserFilms )
    $(document).on('change', '#userListsOptions', FL.Films.addFilmTolist )
  },

  displayContent: function(xhr, data, status){
    $('#container').html(data)
  },

  displayModal: function(e){
    e.preventDefault()
    $.get($(this).attr('href'), function(data, status){
      ModalController.queue_modal(data)
    })
  },
  
  endlessScroll: function(){
    self = this
    loading = false
    threshold = 450

    $(window).scroll(function()
    {
      currentPos = $(window).scrollTop() + threshold 
      totalHeight = $(document).height() - $(window).height()

      if(currentPos >= totalHeight && !loading)
      {
        next = $('#filmsLinkNext').attr('href')
        if(!next) return false
          
        loading = true
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

  sortUserFilms: function(){
    url = $(this).attr('value')
    $('#filmsIndex').load(url + ' #filmsContent')
  },

  navigateToOption: function(){
    window.location = $(this).attr('value')
  },

  addFilmTolist: function(){
    url = $(this).attr('value')
    $.ajax({
      url: url,
      type: 'put',
      success: function(html){
        $('#alerts').append(html)

        window.setTimeout(function(){
          $('.alert-box .close').first().click()
        }, 5000)

        if($('#queueListModal').length>0)
          $('#queueListModal .close-reveal-modal').click()
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

        if(!to_action)
          $(document).trigger('film:' + action + ':unactioned', [icon.parents('.film')])

        if(action=='queued')
          return
        
        counter = icon.prev('label')
        counter.text(parseInt(counter.text()) + incr)
      }  
    })
  }
}