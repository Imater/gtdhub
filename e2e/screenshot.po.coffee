###
This file uses the Page Object pattern to define the main page for tests
https://docs.google.com/presentation/d/1B6manhG0zEXkC-H-tPo2vwU06JhL8w9-XCF9oehXzAQ
###
"use strict"

fs = require("fs")

screenshot = (data, filename) ->
  stream = fs.createWriteStream('e2e/screenshots/' + filename)
  stream.write new Buffer(data, "base64")
  stream.end()
  console.info ">> screenshot #{filename} did"

module.exports = (name, cb) ->
  browser.takeScreenshot().then (png) ->
    screenshot png, name
    cb() if cb

