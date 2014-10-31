'use strict'

describe 'Git object', ->
  sampleText = "This is sample text for me"
  # load the controller's module
  beforeEach module('gitStorage')

  GitObject = undefined
  beforeEach inject (_GitObject_) ->
    GitObject = _GitObject_

  it 'exist task model', ->
    expect(GitObject).toBeDefined()

  it 'save blob', ->
    gitObject1 = new GitObject("Short text")
    gitObject2 = new GitObject("Short text")
    expect(gitObject1.name).toBe gitObject2.name

  it 'save blob to object', ->
    gitObject = new GitObject(sampleText)
    expect(gitObject.get()).toBe sampleText
