$(function(){
  RequestsController.init()
})

var RequestsController = {
  lastUri: null,
  init: function(){
    

    $('form').live('ajax:success', function(xhr, view, status)
    {
      xhr.stopPropagation()    
      RequestsController.display(view)
    })
  },

  get: function(uri){
    this.addPushState(uri)
    $.get(uri, RequestsController.display)
  },

  display: function(view){   
    $('#container').html(view)
  },

  linkView: function(href, model, view){
    $.getJSON(href, function(json_data){
      RequestsController.bindView(new model(json_data), view)
    })
  },

  bindView: function(model, view){
    content = $(view)   
    ko.applyBindings(model, content[0])
    $("#featured").orbit({
      directionalNav:true, fluid:false, timer:false
    })
    // $('#container').html(content)
  },

  addPushState: function(uri){
    loc = location.href
    console.log('Addding pushstate: ' + loc)
    history.pushState({lastUrl:loc}, null, uri)
    this.google()
  },

  google: function(){
    if(typeof(_gaq)==='undefined') 
      return
    return _gaq.push(['_trackPageview', '/some-page'])
  }
}