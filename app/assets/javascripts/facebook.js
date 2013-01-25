var FacebookAPI = {

  logged_in: function(){
    viewModel.user.loggedIn(true)
    viewModel.user.loggedOut(false)
  },
  logged_out: function(){
    viewModel.user.loggedIn(false)
    viewModel.user.loggedOut(true)
  },
  login: function login(){

    // FB.login(function(response) 
    // {
    //     if (response.authResponse) 
    //     {
    //       FacebookAPI.logged_in()
    //     } 
    //     else 
    //     {
    //       FacebookAPI.logged_out()
    //       console.log('User cancelled login or did not fully authorize.');
    //     }
    // })
  },

  logout: function logout(){
    FB.logout(function(response) 
    {
      FacebookAPI.logged_out()
      console.log('User is now logged out');
    })
  },

}
