$(function(){

  $('.film-actions a').live('ajax:success', function(xhr,data,status){
    icon = $("i", this)
    icon.toggleClass('actioned unactioned') 
    var data_method = icon.hasClass('actioned') ? 'delete' : 'put'
    $(this).data('method', data_method)
  })
})