'use strict'

describe 'Git DateTime', ->

  # load the controller's module
  beforeEach module('gitStorage')

  GitDateTime = undefined
  beforeEach inject (_GitDateTime_) ->
    GitDateTime = _GitDateTime_

  it 'get date time', ->
    gitDateTime = new GitDateTime()
    expect(gitDateTime.getDateTime().split(" ").length).toBe 2

  it 'get utc', ->
    gitDateTime = new GitDateTime()
    time = gitDateTime.getUTC(gitDateTime.getDateTime())
    expect(typeof time).toBe 'number'
