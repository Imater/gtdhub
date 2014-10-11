'use strict'

describe 'Class storage', ->

  # load the controller's module
  beforeEach module('gtdhubApp')

  Storage = undefined
  TreeModel = undefined
  TaskModel = undefined
  beforeEach inject (_Storage_, _TreeModel_, _TaskModel_) ->
    Storage = _Storage_
    TreeModel = _TreeModel_
    TaskModel = _TaskModel_

  it 'exist', ->
    expect(Storage).toBeDefined()
    storage = new Storage("treeDB")
    expect(storage).toBeDefined()
    expect(storage.name).toBe "treeDB"

  it 'can add model', ->
    storage = new Storage("treeDB")
    expect(storage.add).toBeDefined()
    for i in [1..5]
      model = new TreeModel
        title: "Element №#{i}"
      storage.add(model)
    expect(storage.count()).toBe 5

  it 'can work with 2 storage', ->
    storage1 = new Storage("treeDB")
    storage2 = new Storage("taskDB")
    expect(storage1.count()).toBe 0
    expect(storage2.count()).toBe 0
    for i in [1..5]
      model = new TreeModel
        title: "Element №#{i}"
      storage1.add(model)
      expect(storage1.count()).toBe i

      model2 = new TaskModel
        title: "Task Element №#{i}"
      storage2.add(model2)
      expect(storage2.count()).toBe i

    expect(storage1.count()).toBe 5
    expect(storage2.count()).toBe 5
