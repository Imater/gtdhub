'use strict'

describe 'Git tree', ->

  # load the controller's module
  beforeEach module('gitStorage')

  GitCommit = undefined
  GitDateTime = undefined
  beforeEach inject (_GitCommit_, _GitDateTime_) ->
    GitCommit = _GitCommit_
    GitDateTime = _GitDateTime_

  it 'exist task model', ->
    expect(GitCommit).toBeDefined()

  it 'save Commit to object and back', ->
    dir =
      tree: "treeHASH"
      parent: "parentCommitHASH"
      author: "imater@eugene.leonar@gmail.com"
      date: new GitDateTime().getDateTime()
      message: 'hello'
    gitCommit = new GitCommit(dir)
    for keyName of dir
      expect(gitCommit.getObject(gitCommit.getString())[keyName]).toBe dir[keyName]
    expect(JSON.stringify(dir).length).toBeGreaterThan gitCommit.commit.length

  it 'Make commit without dateTime', ->
    dir =
      tree: "treeHASH"
      parent: "parentCommitHASH"
      author: "imater@eugene.leonar@gmail.com"
      message: 'hello'
    gitCommit = new GitCommit(dir)
    expect(gitCommit.getObject(gitCommit.getString()).date).toBeDefined()

