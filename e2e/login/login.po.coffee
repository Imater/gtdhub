###
This file uses the Page Object pattern to define the main page for tests
https://docs.google.com/presentation/d/1B6manhG0zEXkC-H-tPo2vwU06JhL8w9-XCF9oehXzAQ
###
"use strict"
LoginPage = ->
  @h1El = element by_.css "h1"
  @loginInput = element by_.model "user.email"
  @passwordInput = element by_.model "user.password"
  @loginBtn = element by_.css "[type='submit']"
  return


  #@imgEl = @heroEl.element(by_.css("img"))
  #@newThing = element(by_.model("newThing"))
  #@addThingBtn = element( by_.css('[ng-click="addThing()"]') )
  #@deleteThingBtn = element( by_.css('[ng-click="deleteThing(thing)"]') )

module.exports = new LoginPage()