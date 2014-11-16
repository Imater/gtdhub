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
    childs: [
      _id: '26'
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
    _id: '2'
    title: 'title 2'
    text: 'sample text first'
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

  xit 'commit', ()->
    git = new Git()
    tm = Date.now()
    for i in [0..10]
      sampleTree.push
        _id: i*2
        title: "Hello"+i*100000
        text: JSON.stringify angular
      sampleTree.push
        _id: i
        title: "Hello"+i*100000
        text: "Sample text" + i
      mainTree = git.status(sampleTree)
      git.commit(mainTree, "commit №#{i}")
      commitHash = git.gitStorageRef.get 'HEAD'
    commitHash = git.gitStorageRef.get 'HEAD'
    expect(git.log().length).toBeGreaterThan 6
    tm = Date.now()
    tree = git.checkout(git.log()[5].hash)
    console.info 'checkout time = ', Date.now() - tm
    showSizes(git)
    tm = Date.now()
    gc = git.gc()
    console.info Date.now() - tm, ' ms duration gc'
    showSizes(git)
    console.info JSON.stringify git.gitStorage, null, "  "

  it 'test for gc', ->
    show = (git, message)->
      console.info "------------ #{message}-----------"
      console.info JSON.stringify git.gitStorage, null, "  "
      console.info "size: #{git.gitStorage.length()}"
    sampleTree = [
      _id: 'd1'
      text: ''
    ,
      _id: 'd2'
      text: ''
    ]

    git = new Git()
    mainTree = git.status sampleTree
    show git, 'init'
    git.commit mainTree, 'init commit'
    show git, 'add commit'

    git.commit mainTree, 'init commit'
    show git, 'add commit'

    sampleTree[0].text = 'First text'
    sampleTree[1].text = 'Second text'
    mainTree = git.status sampleTree
    git.commit mainTree, 'commit 1'
    show git, 'add some changes'

    sampleTree[0].text = 'First text make bigger'
    sampleTree[1].text = 'Second text make bigger too'
    mainTree = git.status sampleTree
    git.commit mainTree, 'commit 1'
    show git, 'add some changes'

    git.gc()
    show git, 'gc'


