'use strict'

describe 'Git pack', ->

  # load the controller's module
  beforeEach module('gitStorage')

  GitPack = undefined
  beforeEach inject (_GitPack_) ->
    GitPack = _GitPack_

  it 'exist pack model', ->
    expect GitPack
      .toBeDefined()

  it 'set and get pack model', ->
    map =
      type: 'type'
      size: 77
      deep: 1
      baseHash: 'baseHash'
      diff: 'diff'
    gitPack = new GitPack map
    result = gitPack.get(gitPack.getString())
    expect JSON.stringify result
      .toBe JSON.stringify map

  it 'set and get pack model for base', ->
    map =
      type: 'type'
      size: 77
      blob: 'blob'
    gitPack = new GitPack map
    result = gitPack.get(gitPack.getString())
    expect JSON.stringify result
      .toBe JSON.stringify map
