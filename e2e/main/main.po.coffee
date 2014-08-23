###
This file uses the Page Object pattern to define the main page for tests
https://docs.google.com/presentation/d/1B6manhG0zEXkC-H-tPo2vwU06JhL8w9-XCF9oehXzAQ
###
"use strict"
MainPage = ->
  @heroEl = element(by_.css(".hero-unit"))
  @h4El = @heroEl.element(by_.css("h4"))
  @imgEl = @heroEl.element(by_.css("img"))
  @newThing = element(by_.model("newThing"))
  @addThingBtn = element( by_.css('[ng-click="addThing()"]') )
  @deleteThingBtn = element( by_.css('[ng-click="deleteThing(thing)"]') )
  @helloLoginned = element by_.binding "getCurrentUser().name"
  @logoutBtn = element( by_.css('[ng-click="logout()"]') )
  return

module.exports = new MainPage()