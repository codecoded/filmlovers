$(function(){
  
  window.viewModel = {
    user: new UserModel()
    // invitations: new InvitationsModel()
  }
  viewModel.user.load()
  ko.applyBindings(viewModel)
})

function loadFriends()
{
  //get array of friends
  FB.api('/me/friends', function(response) {   
    viewModel.invitations.load(response.data)
  });
}
