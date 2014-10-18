'use strict'

describe 'Git service', ->

  # load the controller's module
  beforeEach module('gtdhubApp')

  GitService = undefined
  GitObject = undefined
  ShaService = undefined
  Traverse = undefined
  treeSrv = undefined
  beforeEach inject (_GitService_, _GitObject_, _ShaService_, _Traverse_, _treeSrv_) ->
    GitService = _GitService_
    GitObject = _GitObject_
    ShaService = _ShaService_
    Traverse = _Traverse_
    treeSrv = _treeSrv_

  xit 'exist task model', ->
    expect(GitService).toBeDefined()
    gitService = new GitService()
    for i in [0..5]
      gitService.addObject "Object " + i
    expect(gitService.getObject(ShaService.sha(JSON.stringify("Object 3")))).toBeDefined()

  xit 'add new object', ->
    gitService = new GitService()
    gitService.add
      type: "tree"
      _id: "77"
      blob:
        title: "first file"
    gitService.add
      type: "task"
      _id: "77"
      blob:
        title: "first file"
    gitService.add
      type: "task"
      _id: "77"
      blob:
        title: "first file"
    expect(Object.keys(gitService.objects).length).toBe 3

  it 'add change then commit', ->
    gitService1 = new GitService()
    gitService1.add
      type: "tree"
      _id: "77"
      blob:
        title: "first file"
    gitService1.add
      type: "tree"
      _id: "77"
      blob:
        title: "second file"

    gitService2 = new GitService()
    gitService2.add
      type: "tree"
      _id: "77"
      blob:
        title: "first file changed"
    gitService2.add
      type: "tree"
      _id: "77"
      blob:
        title: "second file"
    gitService2.add
      type: "tree"
      _id: "77"
      blob:
        title: "third file"

    gitService2.commit gitService1, "first commit"

  it 'make tree', ->
    gitService = new GitService()
    tree = treeSrv.get()
    resultHash = gitService.addTree(tree);
    gitService.addCommit(resultHash, "Первый коммит")
    restore = gitService.restoreTree(treeSrv._Tree, resultHash)
    expect(_.isEqual(tree, restore)).toBe true

  it 'make history', ->
    gitService = new GitService()
    tree = treeSrv.get()
    history = []
    for i in [0..10]
      tm = new Date().getTime()
      tree.title = "Change title №"+i
      resultHash = gitService.addTree(tree);
      c = gitService.addCommit(resultHash, "Коммит №"+i)
      history.push gitService.refs.HEAD
      gitService.refs
      console.info "MAKE TREE =", new Date() - tm
    for hash in history
      tm = new Date().getTime()
      thisTreeHash = JSON.parse(gitService.objects[hash]).tree
      restore = gitService.restoreTree(treeSrv._Tree, thisTreeHash)
      #console.info JSON.stringify restore, null, "\t"
      console.info restore.title
      console.info "RESTORE TREE =", new Date() - tm
    restore = gitService.restoreTree(treeSrv._Tree, resultHash)
    expect(_.isEqual(tree, restore)).toBe true
