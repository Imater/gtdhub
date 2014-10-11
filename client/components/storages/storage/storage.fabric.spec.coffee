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

  it 'map reduce', ->
    storage = new Storage("treeDB")
    expect(storage.add).toBeDefined()
    for i in [1..20]
      model = new TreeModel
        title: "Element №#{i}"
      storage.add(model)
    expect(storage.count()).toBe 20

    mapFn = (key, value)->
      return true if value?.title?.indexOf("8")!=-1
    reduceFn = (memo, value)->
      memo = (memo || value.title.length)/2 + (value?.title?.length)/2
    result = storage.mapReduce mapFn, reduceFn, 0
    expect(result).toBe 10.5

  it 'map function', ->
    storage = new Storage("treeDB")
    expect(storage.add).toBeDefined()
    for i in [1..20]
      model = new TreeModel
        title: "Element №#{i}"
      storage.add(model)
    expect(storage.count()).toBe 20
    mapFn = (key, value)->
      return true if value?.title?.indexOf("8")!=-1
    result = storage.mapReduce mapFn
    expect(result.length).toBe 2

  it 'find by parent id', ->
    storage = new Storage("treeDB")
    parent_id = 1
    for i in [1..20]
      model = new TreeModel
        title: "Element №#{i}"
      model.set
        parent_id: parent_id
      parent_id = model.get()._id
      storage.add(model)

    for i in [1..50]
      storage.add new TreeModel
        parent_id: parent_id
        order: 51-i
        title: "child"+i

    lastElement = storage.getById(parent_id)
    expect(lastElement.title).toBe "Element №20"
    childsList = storage.getByParentId(lastElement.parent_id)
    expect(childsList?[0].title).toBe "Element №20"

    t = new Date().getTime();
    childsList = storage.getByParentId(lastElement._id)
    expect(childsList?[0].title).toBe "child1"
    expect(childsList?[1].title).toBe "child2"
    expect(childsList?[2].title).toBe "child3"

    childsList = storage.getByParentId lastElement._id, (element)->
      element?.order
    expect(childsList?[0].title).toBe "child50"
    expect(childsList?[1].title).toBe "child49"
    expect(childsList?[2].title).toBe "child48"

    childsList = storage.getByParentId lastElement._id, (element)->
      -element?.order
    expect(childsList?[0].title).toBe "child1"
    expect(childsList?[1].title).toBe "child2"
    expect(childsList?[2].title).toBe "child3"
