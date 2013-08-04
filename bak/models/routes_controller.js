
function RoutesController(){
  var self = this

  self.films_page = function(data, event){
    console.log(event.target)
    console.log(data)
    return false;
  }
}