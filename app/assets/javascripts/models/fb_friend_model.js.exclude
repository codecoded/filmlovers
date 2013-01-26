function FBFriendModel(data){
  var model = this;
  model.name = data.name
  model.id = data.id
}

function InvitationsModel(){
  var model = this
  model.friends = ko.observableArray([])
  model.invites = ko.observableArray([])
  model.filter = ko.observable("")
  model.filteredItems = ko.dependentObservable(friendsFilter, model)

  model.removeInvite = removeInvite
  model.addInvite = addInvite
  model.load = function(fb_data){
    var mappedData = $.map(fb_data, function (item) {return new FBFriendModel(item)})
    mappedData.sort(sortFriends)
    model.friends(mappedData)
  }
}

function removeInvite(model){
  var friend = this
  model.invites.remove(friend); 
  model.friends.unshift(friend); 
  model.friends.sort(sortFriends)
}

function addInvite(model){
  var friend = this
  model.invites.remove
  model.invites.push(friend);
  model.friends.remove(friend);
}

function sortFriends(friendA, friendB){
  return friendA.name == friendB.name ? 0 : (friendA.name < friendB.name ? -1 : 1) 
}

function friendsFilter(){
  var model = this
  var filter = model.filter().toLowerCase();

  if (!filter) 
    return model.friends();

  return ko.utils.arrayFilter(model.friends(), function(item) {
    return item.name.toLowerCase().indexOf(filter) > -1
    // return ko.utils.stringStartsWith(item.name.toLowerCase(), filter)
  })
}