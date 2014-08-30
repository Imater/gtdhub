'use strict'

describe 'Service: Task', ->

  # load the service's module
  beforeEach module('gtdhubApp')

  # instantiate service
  Task = undefined
  beforeEach inject((_Task_) ->
    Task = _Task_
  )
  it 'should do something', ->
    expect(!!Task).toBe true