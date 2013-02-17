$(function(){
  RequestsController.init()
})

var RequestsController = {
  init: function(){
    

    $('a, form').live('ajax:success', function(xhr, view, status)
    {
      xhr.stopPropagation()    
      RequestsController.display(view)
    })
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
    // $('#container').html(content)
  }
}