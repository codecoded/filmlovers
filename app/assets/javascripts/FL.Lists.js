FL.Lists = {
  initialised: false,

  init: function(model){
    if(FL.Lists.initialised) return

    FL.Lists.initSort($('.sortable'))
    FL.Lists.initialised = true
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
      FL.Lists.sort()
    });   
  },

  sort: function(){
    $('.sortable li').each(function(index, item){
      $(".index", item).text(index+1)
      $("#films_list_film_list_items__position", item).val(index+1)
      // item = Bindings.Lists.model.find(item.getAttribute('data-item-id'))
      // item.position(index+1)
    })    
  }

}