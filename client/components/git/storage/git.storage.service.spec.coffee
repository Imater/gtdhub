'use strict'

describe 'Git storage', ->
  # load the controller's module
  beforeEach module('gitStorage')

  GitStorage = undefined
  beforeEach inject (_GitStorage_) ->
    GitStorage = _GitStorage_

  it 'exist task model', ->
    expect(GitStorage).toBeDefined()

  it 'can create two db', ->
    gitStorage1 = new GitStorage('db1')
    gitStorage2 = new GitStorage('db2')

  it 'can set and get value', ->
    gitStorage1 = new GitStorage('db1')
    gitStorage2 = new GitStorage('db2')
    gitStorage1.set('first_param', 'first value')
    gitStorage2.set('second_param', 'second value')
    gitStorage2.set('digital_param', '777')
    expect(gitStorage1.get('first_param')).toBe 'first value'
    expect(gitStorage2.get('first_param')).toBe undefined
    expect(gitStorage2.get('second_param')).toBe 'second value'
    expect(gitStorage2.get('digital_param')).toBe '777'
