function FilmsPageModel(films_page) {
  var self = this;

  
  self.url = ko.observable(films_page.url)
  self.url_previous = ko.observable(films_page.url_previous)
  self.url_next = ko.observable(films_page.url_next)
  self.page_no = ko.observable(films_page.page_no)
  self.total_results = ko.observable(films_page.total_results)
  self.page_size = ko.observable(films_page.page_size)
  self.total_pages = ko.observable(films_page.total_pages)
  self.description = ko.observable(films_page.description)
  

  self.films = ko.observableArray(FilmModel.arrayFromJSON(films_page.films))

}

FilmsPageModel.prototype.update = function(filmModel){

  this.url(filmModel.url())
  this.url_previous(filmModel.url_previous())
  this.url_next(filmModel.url_next())
  this.page_no(filmModel.page_no())
  this.total_results(filmModel.total_results())
  this.description(filmModel.description())

  this.films(filmModel.films())
}
