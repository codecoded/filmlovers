function FilmsPageModel(films_page) {
  var self = this;

  self.page_no = ko.observable(films_page.page_no)
  self.total_results = ko.observable(films_page.total_results)
  self.page_size = ko.observable(films_page.page_size)
  self.total_pages = ko.observable(films_page.total_pages)
  self.description = ko.observable(films_page.description)
  
  self.films = ko.observableArray(FilmsPageModel.fromJSON(films_page.films))

  self.applyBindings = function(container){
    viewModel.films_found = self
    ko.applyBindings(viewModel, container)
  }
}


FilmsPageModel.load = function(uri, view, container) {

  $.getJSON(uri, function(films_data) { 
    $.get(view, function(template_data, status){
      $(container).html(template_data)
      FilmsPageModel.fromJSON(films_data).applyBindings(container)
    })
  })
}

FilmsPageModel.fromJSON = function(json){
  return $.map(json, function (film) {return new FilmModel(film) })
}

