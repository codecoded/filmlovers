FL.Pusher = FL.Pusher || {}

FL.Pusher = {

  key: null,
  channel: null,
  client: null,

  init: function(key, channel){
    pusher.setUpClient(key, channel)
    pusher.key = key
    pusher.channel = channel    
  },  

  authorised: function(){
  },

  subscribe: function(){
    client = new PusherClient(pusher.key, pusher.channel)
  },

  setUpClient: function(key, channel){
    Pusher.log = function(message) {
      if (window.console && window.console.log) window.console.log(message);
    };

    pusher.client = new Pusher(key);
    var channel = pusher.client.subscribe(channel);

    pusher.client.connection.bind('connected', pusher.authorised)
    channel.bind('notification', pusher.receive)
  },

  receive: function(push_envelope) {
    switch(push_envelope.type)
    {
      case 'script':
        return eval(push_envelope.message)
      case 'modal':
        return modalController.queue_modal(push_envelope.message, true)          
      case 'toast':
        return alertsController.display_alert(push_envelope.message)     
      default:
        console.log(push_envelope.message)
    }
  }
}

var pusher = FL.Pusher