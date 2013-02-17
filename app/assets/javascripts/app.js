$(function(){
  $('#fb-login').click(FacebookAPI.login)
  $('#fb-logout').click(FacebookAPI.logout)
  // $('.film-search').click(function(event){
  //   event.preventDefault()
  //   console.log('s')
  //   $(this).closest('form').submit()
  // })

  // $('.target-container').live('ajax:success', function(xhr, data, status){
  //   $('#container').html(data)
  // })
})

function allowDrop(ev)
{
  ev.preventDefault();
}

function drag(ev)
{
  ev.dataTransfer.setData("Text",ev.target.id);
  console.log(ev.target)
}

function drop(ev)
{

  ev.preventDefault();
  var data=ev.dataTransfer.getData("Text");
  console.log(data)
  ev.target.appendChild(document.getElementById(data));
  console.log('dropped')
}
