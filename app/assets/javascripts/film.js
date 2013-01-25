$(function(){
  $(".film-actions i").click( function(){
    icon = $(this)
    icon.toggleClass('actioned unactioned')
    var data_method = icon.hasClass('actioned') ? 'put' : 'delete'
    icon.parent().attr('data-method', data_method )
  })
})