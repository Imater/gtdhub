'use strict'

describe 'Service StorageService should', ->

  # load the controller's module
  beforeEach module('gtdhubApp')

  StorageService = undefined
  beforeEach inject (_StorageService_) ->
    StorageService = _StorageService_

  it 'exist', ->
    expect(!!StorageService).toBe true
    storageService = new StorageService("treeDB")
    expect(storageService.name).toBe "treeDB"

