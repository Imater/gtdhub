'use strict'

describe 'Class storage', ->

  # load the controller's module
  beforeEach module('gtdhubApp')

  Storage = undefined
  beforeEach inject (_Storage_) ->
    Storage = _Storage_

  it 'exist', ->
    expect(Storage).toBeDefined()
    storage = new Storage("treeDB")
    expect(storage).toBeDefined()
    expect(storage.name).toBe "treeDB"

  it 'can save', ->
    storage = new Storage("treeDB")
    expect(storage.name).toBe "treeDB"
