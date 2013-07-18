FL.Users = {}

FL.Users = {
  initialised: false,

  init: function(){
    
    if(FL.Users.initialised) return

    FL.Users.initListeners()
    FL.Users.initialised = true
  },

  initListeners: function(){
    $(document).on('ajax:success', '#signupform, #signinform', function(){window.location = '/'})
    $(document).on('ajax:error', '#signupform', users.registrationError)
    $(document).on('ajax:error', '#signinform', users.loginError)
  },

  registrationError: function(data, xhr, response){
    var self = $(this);
    if(xhr.status===422){
      self.closest('#panelssignup #signupform, #panelslowersignup #signupform').replaceWith($('#signupform', xhr.responseText))     
    }
  },

  loginError: function(data, xhr, response){
    var self = $(this);
    
    if(xhr.status===401){
      $('#signinform small').remove()
      $('#signinform #user_password').after('<small>' + xhr.responseText + '</small>').parent().addClass('error')
    }   
  }
}

users = FL.Users;