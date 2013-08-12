var filters = function(){

  var apply = function(){
    var year = getFilterValueByName('year');
    var decade = getFilterValueByName('decade');
    var genres = getFilterValuesByName('genres');

    var url = "";

    if(year)
      url = '/year/'.concat(year)
    else if(decade)
      url = '/decade/'.concat(decade)

    if(genres)
      url = url + '/genres/'.concat(genres)

    var path = window.location.pathname;
    if(path.indexOf('filter_by') === -1)
      window.location.pathname += "/filter_by" + url
    else
      window.location.pathname = path.substr(0,path.indexOf('filter_by') ).concat('filter_by').concat(url) 

    return url;
  };

  var getFilterValueByName = function(name){
    return $('.filter.selected[data-filter-name="' + name + '"]').attr('data-filter-value');
  }

  var getFilterValuesByName = function(name){
    return $('.filter.selected[data-filter-name="' + name + '"]').map(function(index, item){
      return $(item).attr('data-filter-value');
    }).toArray().join('/');
  }

  return {
    apply: apply,
    getFilterValuesByName: getFilterValuesByName,
    getFilterValueByName: getFilterValueByName
  }

}(jQuery);