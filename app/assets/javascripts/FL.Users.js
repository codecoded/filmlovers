FL.Users = {}

FL.Users = {
  initialised: false,

  init: function(){
    
    if(FL.Users.initialised) return;

    FL.Users.initListeners()
    FL.Users.initialised = true
  },

  initListeners: function(){
    $(document).on('ajax:success', '#signupform, #signinform', function(){window.location = '/'})
    $(document).on('ajax:success', '#profileDetailsForm', function(data, xhr, response){
      window.location = '/'}
    )
    $(document).on('ajax:error', '#signupform', users.registrationError)
    $(document).on('ajax:error', '#profileDetailsForm', users.profileDetailsError)
    $(document).on('ajax:error', '#signinform', users.loginError)
  },

  registrationError: function(data, xhr, response){
    var self = $(this);
    if(xhr.status===422){
      self.closest('#panelssignup #signupform, #panelslowersignup #signupform').replaceWith($('#signupform', xhr.responseText))     
    }
  },

  profileDetailsError: function(data, xhr, response){
    var self = $(this);
    console.log(xhr.responseText)
    if(xhr.status===422){
      $('#profileDetailsForm').replaceWith($('#profileDetailsForm', xhr.responseText))     
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