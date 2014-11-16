'use strict'

describe 'Git diff', ->
  # load the controller's module
  beforeEach module('gitStorage')

  GitDiff = undefined
  beforeEach inject (_GitDiff_) ->
    GitDiff = _GitDiff_

  it 'exist diff model', ->
    expect GitDiff
      .toBeDefined()
    gitDiff = new GitDiff()
    expect gitDiff
      .toBeDefined()

  it 'can make diff and apply patch', ->
    gitDiff = new GitDiff()
    text1 = JSON.stringify
      title: 'Hello man president this text will be deleted'
      childs: [
        'yes'
        'no'
        'maybe'
      ]
    text2 = JSON.stringify
      title: 'Hello mister president'
      childs: [
        'yes'
        'no'
        'maybe'
      ]
    patch = gitDiff.patchMake text1, text2
    result = gitDiff.patchApply text1, patch
    expect result
      .toBe text2
