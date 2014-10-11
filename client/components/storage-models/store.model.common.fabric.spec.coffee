'use strict'

describe 'Model Tree', ->

  exampleTree =
    title: "Hello"
    tags: [1,2,3,4,5]

  # load the controller's module
  beforeEach module('gtdhubApp')

  TaskModel = undefined
  TreeModel = undefined
  beforeEach inject (_TaskModel_, _TreeModel_) ->
    TaskModel = _TaskModel_
    TreeModel = _TreeModel_

  it 'exist tree model', ->
    expect(TreeModel).toBeDefined()
    treeModel = new TreeModel("tree", exampleTree)
    expect(treeModel).toBeDefined()
    expect(treeModel.get().title).toBe "New tree element"

  it 'set method', ->
    expect(TreeModel).toBeDefined()
    treeModel = new TreeModel("tree", exampleTree)
    expect(treeModel).toBeDefined()
    treeModel.set({title: "Bye"})
    expect(treeModel.get().title).toBe "Bye"

  it 'set directly', ->
    expect(TreeModel).toBeDefined()
    treeModel = new TreeModel("tree", exampleTree)
    expect(treeModel).toBeDefined()
    treeModel.get().title = "Bye"
    expect(treeModel.get().title).toBe "Bye"

  it 'exist task model', ->
    expect(TaskModel).toBeDefined()
    taskModel = new TaskModel("task", exampleTree)
    expect(taskModel).toBeDefined()
    expect(taskModel.get().title).toBe "New task"
