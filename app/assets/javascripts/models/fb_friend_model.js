function FBFriendModel(data){
  var self = this;
  self.id = data.uid
  self.name = data.name
  self.username = data.username
  self.avatarURL = 'https://graph.facebook.com/' + data.uid + '/picture'
}

function FriendsList(friends){
  var self = this
  self.friends = ko.observableArray(friends)

  // model.selectedFriends = ko.observableArray([])
  // model.filter = ko.observable("")
  // model.showing = ko.observable('all-friends')
  // model.isShowingAllFriends = ko.computed(function(){
  //   return model.showing() == 'all-friends'
  // })
  // model.isShowingAppFriends = ko.computed(function(){
  //   return model.showing() == 'app-friends'
  // })
  // model.showAppFriends = showAppFriends
  // model.showAllFriends = showAllFriends
  // model.filteredItems = ko.computed(friendsFilter, model)

  // model.removeFriend = removeFriend
  // model.addFriend = addFriend
  // model.selectAll = selectAll
  // model.addFriendByUID = function addFriendByUID(uid){
  //   friend = $.grep(model.friends(), function(friend){ return friend.id == uid })[0]
  //   if(friend) model.addFriend(friend)
  // }

  // model.load = function(fb_data){
  //   var mappedData = $.map(fb_data, function (item) {return new FBFriendModel(item)})
  //   mappedData.sort(sortFriends)
  //   model.friends(mappedData)
  //   model.selectedFriends([])
  // }
}

// function removeFriend(friend){
//   var model = this
//   model.selectedFriends.remove(friend); 
//   model.friends.unshift(friend);
//   model.friends.sort(sortFriends)
// }

// function addFriend(friend){
//   var model = this
//   model.selectedFriends.push(friend);
//   model.friends.remove(friend);
// }

// function showAllFriends(){
//   var model = this
//   model.showing('all-friends')
// }

// function showAppFriends(){
//   var model = this
//   model.showing('app-friends')
// }

// function selectAll(){
//   var model = this
//   ko.utils.arrayForEach(model.filteredItems(), function(friend) {
//     model.addFriend(friend)
//   })
// }

// function sortFriends(friendA, friendB){
//   return friendA.name == friendB.name ? 0 : (friendA.name < friendB.name ? -1 : 1) 
// }

// function friendsFilter(){
//   var model = this
//   var filter = model.filter().toLowerCase()
//   var isShowingAppFriends = model.isShowingAppFriends()

//   //if (!filter) return model.friends();

//   return ko.utils.arrayFilter(model.friends(), function(item) {
//     return (item.name.toLowerCase().indexOf(filter) > -1) && (isShowingAppFriends ? item.installed == true : true)
//   })
// }


