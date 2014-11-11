'use strict'

describe 'Git main service', ->
  # load the controller's module
  beforeEach module('gitStorage')

  Git = undefined
  sampleTree = [
    _id: '1'
    _tm: 123456
    title: 'title 1'
    text: 'sample text first'
  ,
    _id: '2'
    title: 'title 2'
    text: 'sample text first'
    childs: [
      _id: '6'
      title: 'inside folder 1 title 3'
      text: 'sample text first'
      tasks: [
        _id: '61'
        title: 'do something'
        text: 'task text'
      ,
        _id: '62'
        title: 'do something'
        text: 'task text'
      ,
        _id: '63'
        title: 'do something'
        text: 'task text'
      ]
    ,
      _id: '7'
      title: 'inside folder 1 title 4'
      text: 'sample text'
      childs: [
        _id: '71'
        title: 'subchild'
        text: 'hello'
      ]
    ]
  ]

  showSizes = (git)->
    console.info "sampleTree length", (JSON.stringify sampleTree).length
    console.info "storage length = ", git.gitStorage.length()

  beforeEach inject (_Git_) ->
    Git = _Git_

  it 'exist git', ->
    expect(Git).toBeDefined()

  it 'status work', ()->
    git = new Git()
    expect(git.status).toBeDefined()

  it 'commit', ()->
    git = new Git()
    tm = Date.now()
    for i in [0..5]
      sampleTree.push
        _id: i
        title: "Hello"
        text: "Sample text"
      mainTree = git.status(sampleTree)
      git.commit(mainTree, "commit №#{i}")
      commitHash = git.gitStorageRef.get 'HEAD'
    commitHash = git.gitStorageRef.get 'HEAD'
    expect(git.log().length).toBe 6
    tree = git.checkout(git.log()[0].hash)
    console.info JSON.stringify tree, null, "  "
