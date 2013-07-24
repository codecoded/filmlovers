FL.Lists = {
  initialised: false,

  init: function(model){
    if(FL.Lists.initialised) return

    // FL.Lists.initSort($('.sortable'))
    FL.Lists.initListeners()
    FL.Lists.initialised = true
  },

  initListeners: function(){
    $(document).on('click', ".overview-toggle", FL.Lists.overviewToggle)
    $(document).on('click', "button[data-action=delete-film-item]", FL.Lists.deleteFilmItem)
  },

  initSort: function(sorter){
    sorter.sortable({ 
      forcePlaceholderSize: true, 
      containment:'window', 
      cursor: 'move', 
      forceHelperSize: true, 
      helper: "clone"})

    sorter.on("sortupdate", FL.Lists.sort);   
  },

  sort: function(event, ui){
    $('.sortable li').each(function(index, item){
      $(".index", item).text(index+1)
      $("#films_list_film_list_items__position", item).val(index+1)
    })    
  },

  addFilm: function(url){
    $.ajax({
      url: url,
      type: 'get',
      success: function(html){
        $('.sortable').append(html)
        FL.Lists.sort()
      } 
    })   
  },

  overviewToggle: function(){
    $(this).siblings('.film-summary').toggle()
    caption = $(this).text() == 'more info' ? 'close' : 'more info'
    $(this).text(caption)
  },

  deleteFilmItem: function(e){
    e.preventDefault()
    $(this).parents('li').remove()
    FL.Lists.sort()
  }  
}