FL.Recommendations = {}

FL.Recommendations = {
  initialised: false,

  init: function(){
    
    if(FL.Recommendations.initialised) return

    FL.Recommendations.initListeners()
    FL.Recommendations.initialised = true
  },

  initListeners: function(){
    $(document).on('ajax:success', 'a[data-action="recommendation"]', FL.Recommendations.recommendation)
  },

  recommendation: function(evt, data, status, xhr){
    var link = $(this);
    link.parents('li.recommendation').fadeOut(function(){$(this).remove()})
  }
}