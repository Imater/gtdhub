screenshot = require("../screenshot.po")

#e2e test.
"use strict"
describe "Main View", ->
  page = undefined
  beforeEach ->
    browser.get "/"
    page = require("./main.po")

  it "should include jumbotron with correct data", ->
    expect(page.h4El.getText()).toBe "Gtdhub.com"
    expect(page.imgEl.getAttribute("src")).toMatch /assets\/images\/logotype.png$/
    expect(page.imgEl.getAttribute("alt")).toBe "I'm Yeoman"

  it "can add one task", (done) ->
    title = 'new Task №' + new Date().getTime()
    page.newThing.sendKeys title
    page.addThingBtn.click()
    expect(element.all(by_.binding("thing.name")).last().getText()).toContain title
    screenshot "exception1.png", () ->
      element.all( by_.css('[ng-click="deleteThing(thing)"]') ).last().click()
      expect(element.all(by_.binding("thing.name")).last().getText()).not.toContain title
      screenshot "exception2.png"
      done()

