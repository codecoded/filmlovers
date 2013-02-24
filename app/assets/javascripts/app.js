$(function(){

  ViewModel.init()

  $('#fb-login').click(FacebookAPI.login)
  $('#fb-logout').click(FacebookAPI.logout)  

  $('#lnkQueueListModal').on('click', ViewModel.displayQueueListModal)
  $('#signin-link').on('click', ViewModel.displaySignInModal)

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
