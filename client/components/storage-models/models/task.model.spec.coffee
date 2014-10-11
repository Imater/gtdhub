'use strict'

describe 'Model Task', ->

  # load the controller's module
  beforeEach module('gtdhubApp')

  TaskModel = undefined
  beforeEach inject (_TaskModel_) ->
    TaskModel = _TaskModel_

  it 'exist task model', ->
    expect(TaskModel).toBeDefined()
    taskModel = new TaskModel
      title: "Task"
      date: new Date();
    expect(taskModel).toBeDefined()
    expect(taskModel.get().title).toBe "Task"

  it 'create default', ->
    expect(TaskModel).toBeDefined()
    taskModel = new TaskModel()
    expect(taskModel.get().title).toBe "New task"

  it 'create and set later', ->
    expect(TaskModel).toBeDefined()
    taskModel = new TaskModel()
    taskModel.set
      title: "New Title of task"
    expect(taskModel.get().title).toBe "New Title of task"
