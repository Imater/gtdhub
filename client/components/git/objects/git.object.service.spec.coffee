'use strict'

describe 'Git object', ->

  # load the controller's module
  beforeEach module('gtdhubApp')

  GitObject = undefined
  beforeEach inject (_GitObject_) ->
    GitObject = _GitObject_

  it 'exist task model', ->
    expect(GitObject).toBeDefined()

  it 'save blob', ->
    gitObject1 = new GitObject("Short text")
    gitObject2 = new GitObject("Short text")
    expect(gitObject1.name).toBe gitObject2.name

  xit 'save blob to object', ->
    gitObject = new GitObject("New text to be object")
    console.info gitObject.get()
