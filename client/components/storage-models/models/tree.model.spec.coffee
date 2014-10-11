'use strict'

describe 'Model Tree', ->

  # load the controller's module
  beforeEach module('gtdhubApp')

  TreeModel = undefined
  beforeEach inject (_TreeModel_) ->
    TreeModel = _TreeModel_

  it 'exist task model', ->
    expect(TreeModel).toBeDefined()
    treeModel = new TreeModel
      title: "Tree"
      date: new Date();
    expect(treeModel).toBeDefined()
    expect(treeModel.get().title).toBe "Tree"

  it 'create default', ->
    expect(TreeModel).toBeDefined()
    treeModel = new TreeModel()
    expect(treeModel.get().title).toContain "New"

  it 'create and set later', ->
    expect(TreeModel).toBeDefined()
    treeModel = new TreeModel()
    treeModel.set
      title: "New Title of task"
    expect(treeModel.get().title).toBe "New Title of task"

  it 'can generate _id itself', ->
    treeModel = new TreeModel
      _id: "111"
    treeModel.set
      title: "New Title of task"
    expect(treeModel.get()._id).toBe "111"
