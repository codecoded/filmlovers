FL.Search = {}

FL.Search = {
  initialised: false,

  init: function(){
    
    if(search.initialised) return
    search.initListeners()
    search.initialised = true
  },

  initListeners: function(){
    $(document).on('ajax:success', 'nav.pagination', search.displayContent);
  },

  displayContent: function(event, data, status, xhr){
    $('#search-results-container').html($('#search-results', data));
  }     
}
var search = FL.Search