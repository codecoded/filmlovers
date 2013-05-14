FL.Users = {}

FL.Users = {
  initialised: false,

  init: function(){
    
    if(FL.Users.initialised) return

    FL.Users.initListeners()
    FL.Users.initialised = true
  },

  initListeners: function(){
    $(document).on('ajax:success', 'a[data-action="friendship"]', FL.Users.friendship)
  },

  friendship: function(evt, data, status, xhr){
    var link = $(this);
    var to_action = link.data('method') == 'put'
    link.data('method', (to_action ? 'delete' : 'put'))
    link.toggleClass('success alert')
    link.find('span').text(to_action ? 'remove friendship' : 'create friendship')
    link.find('i').toggleClass('icon-link icon-unlink')
    // $('#alerts').append(xhr.responseText)
    //   window.setTimeout(function(){
    //     $('.alert-box').fadeOut(function(){$(this).remove()})
    //   }, 3500)
  }
}