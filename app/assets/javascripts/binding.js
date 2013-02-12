$(function(){
  
   $.getJSON('/current_user', function(json)
   {
      window.viewModel = {
        user: new UserModel(json)
      }
      
      FilmsQueueModel.load(viewModel.user, document.getElementById('footer'))
      ko.applyBindings(viewModel, document.getElementById('header'))
  })
})

// function loadFriends()
// {
//   //get array of friends
//   FB.api('/me/friends', function(response) {   
//     viewModel.invitations.load(response.data)
//   });
// }
