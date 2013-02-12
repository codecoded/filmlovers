$(function(){
  requestsController.init()
})

var requestsController = {
  init: function(){
    $('a[data-template="films"], form[data-template="films"]').live('ajax:success', function(xhr, json_data,status){
      var template = '/templates/' + $(this).data('template')

      $.get(template, function(template_data,status){
        var container = document.getElementById('container')
        $(container).html(template_data)
        new FilmsPageModel(json_data).applyBindings(container)
      })
    })

    // $('a[data-template="films"], form[data-template="films"]').click(function(event){
    //   event.preventDefault()

    //   var uri = $(this).attr('href')
    //   var template = '/templates/' + $(this).data('template')
    //   var container = document.getElementById('container')
    //   FilmsModel.load(uri, template, container)
    // })

  }
}