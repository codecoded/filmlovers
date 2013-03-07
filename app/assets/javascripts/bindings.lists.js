$(document).on('FilmsListModel:binded', function(event, model){Bindings.Lists.init(model)})

Bindings.Lists = {
  model: null,

  init: function(model){
    Bindings.Lists.model = model
    Bindings.Lists.initSort($('.sortable'))
  },

  initSort: function(sorter){

    sorter.sortable({ 
      forcePlaceholderSize: true, 
      containment:'window', 
      cursor: 'move', 
      forceHelperSize: true, 
      helper: "clone"})

    // sorter.sortable({start: Bindings.Lists.model.sortstart, stop:  Bindings.Lists.model.sortstop, update:  Bindings.Lists.model.sortupdate})

    sorter.on( "sortupdate", function(event, ui){
      $('[data-item-id]', sorter).each(function(index, item){
        film = Bindings.Lists.model.find(item.getAttribute('data-item-id'))
        film.position(index+1)
      })
    });   
  }
}