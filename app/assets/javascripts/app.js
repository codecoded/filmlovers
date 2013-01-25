$(function(){
  $('#fb-login').click(FacebookAPI.login)
  $('#fb-logout').click(FacebookAPI.logout)
  $('.film-search').click(function(query){
    $(this).closest('form').submit()
  })
})