
$(function(){

  if(FL)
  {
    if(FL.Films)
      FL.Films.init()
    if(FL.Lists)
      FL.Lists.init()
    if(FL.Users)
      FL.Users.init()
    if(FL.Friendships)
      FL.Friendships.init()
    if(FL.Recommendations)
      FL.Recommendations.init()
  }
})
