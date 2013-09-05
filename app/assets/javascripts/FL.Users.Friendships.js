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
    $(document).on('ajax:before', '.friendship a[data-friendship]', function(e){e.preventDefault();e.stopPropagation()})
    $(document).on('ajax:success', '.friendship a[data-friendship="request"]', friendships.requested)
    $(document).on('ajax:success', '.friendship a[data-friendship="confirm"]', friendships.confirmed)
    $(document).on('ajax:success', '.friendship a[data-friendship="ignore"]', friendships.ignored)
    $(document).on('ajax:success', 'a[data-friendship="delete"]', friendships.deleted)
    $(document).on('ajax:success', '.friendship a[data-friendship="cancel"]', friendships.cancelled)

  },
  
  requested: function(evt, data, status, xhr){
    var link = $(this);
    link.closest('.friendship').replaceWith(data)
    if(link.data('state')==='received') friendships.counter().decr()
  },

  cancelled: function(evt, data, status, xhr){
    var link = $(this);
    link.closest('.friendship').replaceWith(data)
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
