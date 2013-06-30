FL.Friendships = {
  initialised: false,


  init: function(){
    
    if(friendships.initialised) return
    friendships.initListeners();
    friendships.initialised = true;
  },

  counter: function(){
    return FL.counter('friendships');
  },

  initListeners: function(){
    $(document).on('ajax:success', '.friendship a[data-action="request"]', friendships.requested)
    $(document).on('ajax:success', '.friendship a[data-action="confirm"]', friendships.confirmed)
    $(document).on('ajax:success', '.friendship a[data-action="ignore"]', friendships.ignored)
    $(document).on('ajax:success', '.friendship a[data-action="delete"]', friendships.deleted)
    $(document).on('ajax:success', '.friendship a[data-action="cancel"]', friendships.cancelled)

  },
  
  requested: function(evt, data, status, xhr){
    var link = $(this);
    link.closest('td').html(data)
    if(link.data('state')==='received') friendships.counter().decr()
  },

  cancelled: function(evt, data, status, xhr){
    var link = $(this);
    link.closest('td').html(data)
  },

  confirmed: function(evt, data, status, xhr){
    console.log('confirmed')
    var link = $(this);
    link.closest('td').html(data)
    if(link.data('state')==='received') friendships.counter().decr()
  },

  ignored: function(evt, data, status, xhr){
    var link = $(this);
    link.closest('tr').remove()
    if(link.data('state')==='received') friendships.counter().decr()
  },

  deleted: function(evt, data, status, xhr){
    var link = $(this);
    link.closest('tr').remove()
    if(link.data('state')==='received') friendships.counter().decr()
  }
}

friendships = FL.Friendships;
