'use strict'

describe 'Git main service', ->
  # load the controller's module
  beforeEach module('gitStorage')

  show = (git, message)->
    console.info "------------ #{message}-----------"
    console.info JSON.stringify git, null, "  "
    console.info "size: #{git.gitStorage.length()}"
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

  it 'commit', (cb)->
    localStorage.clear()
    git = new Git()
    tm = Date.now()
    async.each [0..10], (i, callback)->
      if true
        sampleTree.push
          _id: i*2
          title: "Hello"
          text: "text"+i*100000
        sampleTree.push
          _id: i
          title: "Hello"
          text: "Sample text"+i*100000
      else
        sampleTree[0].title = "sample "+i
        sampleTree[1].childs[0].text = "Hellp me" + sampleTree[1].childs[0].text
      git.status sampleTree, (err, mainTree)->
        git.commit mainTree, "commit №#{i}", (err)->
          git.gitStorageRef.getAsync 'HEAD', (err, commitHash)->
            callback()
    , ()->
      git.gitStorageRef.getAsync 'HEAD', (err, commitHash) ->
        git.log (err, log)->
          expect(log.length).toBeGreaterThan 6
          tm = Date.now()
          git.checkout log[0].hash, (err, tree) ->
            console.info 'checkout time = ', Date.now() - tm
            showSizes(git)
            console.info "old length in storage", JSON.stringify(localStorage).length
            tm = Date.now()
            git.gc (err) ->
              console.info Date.now() - tm, ' ms duration gc'
              #console.info JSON.stringify tree, null, "  "
              console.info "new length in storage", JSON.stringify(localStorage).length
              cb()
          #
          ###
          gc = git.gc()
          console.info Date.now() - tm, ' ms duration gc'
          showSizes(git)
          console.info JSON.stringify git.gitStorage, null, "  "
          ###

  xit 'pack storage', ->
    git = new Git('db1')
    text1 = 'hello I need mome'
    text2 = 'hello i need some time to change'
    git.gitStorage.set 'h1', JSON.stringify text1 #first version
    git.gitStorage.set 'h2', JSON.stringify text2 #second version
    git.pack 'h1', 'h2'
    expect git.gitStorage.get 'h1'
      .toBeDefined()
    expect git.gitStorage.get 'h2'
      .toBeDefined()

  xit 'test for gc', ->
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

  xit 'use async set', (async) ->
    git = new Git()
    _mainTree = undefined
    show git
    git.status sampleTree, (err, mainTree) ->
      _mainTree = mainTree
      console.info 'mainTree', _mainTree
      show git, 'tree'
      async()
