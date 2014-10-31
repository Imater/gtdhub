'use strict'

describe 'Git service', ->

  # load the controller's module
  beforeEach module('gitStorage')

  GitService = undefined
  GitObject = undefined
  ShaService = undefined
  beforeEach inject (_GitService_, _GitObject_, _GitSha_) ->
    GitService = _GitService_
    GitObject = _GitObject_
    ShaService = _GitSha_

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

  xit 'make tree', ->
    gitService = new GitService()
    tree = treeSrv.get()
    resultHash = gitService.addTree(tree);
    gitService.addCommit(resultHash, "Первый коммит")
    restore = gitService.restoreTree(treeSrv._Tree, resultHash)
    expect(_.isEqual(tree, restore)).toBe true

  xit 'make history', ->
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
    restore = gitService.restoreTree(treeSrv._Tree, resultHash)
    expect(_.isEqual(tree, restore)).toBe true

  xit 'make tree by big chunk', ->
    gitService = new GitService()
    tree = new treeSrv._Tree
      title: "Главный узел"
    tree.addChild new treeSrv._Tree
      title: "Внук №1"
    t = tree.addChild new treeSrv._Tree
      title: "Внук №2"
    t.addChild new treeSrv._Tree
      title: "Внук внука"
    #tree = treeSrv.get()
    #console.info JSON.stringify tree, null, "\t"
    resultHash = gitService.addTreeBig(tree);
    gitService.addCommit(resultHash, "Первый коммит")
    average = 30;
    if true
      _.each gitService.objects, (val, key)->
        #console.info "------------#{key}-------------"
        old_length = JSON.stringify(gitService.decompress(val)).length
        new_length = val.length
        #console.info gitService.decompress(val), Math.round((1 - new_length/old_length)*100)+"%"
        average = average/2 + Math.round((1 - new_length/old_length)*100)/2
      console.info "AVERAGE COMPRESS = ", average + " %"

    restore = gitService.restoreTreeBig(treeSrv._Tree, resultHash)
    gitService = new GitService()
    for i in [0..500]
      #console.info "----------------------------------------------"
      tree.childs[0].blob.title = "Узел №"+i
      tree.childs[0].blob.text = tree.childs[0].blob.text + " hello №" + i
      tree.childs[1].blob.title = "Узел №"+i*10
      if false
        tree.addChild new treeSrv._Tree
          title: "Ещё один внук №"+10+i+"!!!!!!!!!"
      if i%10 == 1
        resultHash = gitService.addTreeBig(tree)
        gitService.addCommit(resultHash, "Первый коммит "+i)
        console.info 'commit'
      if false
        _.each gitService.objects, (val, key)->
          console.info key, JSON.stringify JSON.parse(val), null, "\t"
    resultHash = gitService.addTreeBig(tree)
    gitService.addCommit(resultHash, "Заключительный коммит")
    console.info "BEFORE:", i, JSON.stringify(gitService).length, Object.keys(gitService.objects).length, resultHash
    console.info JSON.stringify(restore).length
    #console.info JSON.stringify tree, null, "\t"
    #console.info JSON.stringify restore, null, "\t"
    console.info _.isEqual(tree, restore)
    gitService.gc()
    console.info "AFTER:", i, JSON.stringify(gitService).length, Object.keys(gitService.objects).length, resultHash
    #console.info JSON.stringify gitService, null, "\t"
    #expect(_.isEqual(tree, restore)).toBe true


  xit "Test of merge", ->
    console.info "Merge"
    text1 = t: "Я вам пишу , чего же более, что я ещё могу сказать"
    text2 = t: "Я вам господин пишу , чего же более, что я ещё могу сказать"
    text3 = t: "Я милый мой пишу , чего же более, что я ещё могу хорошего сказать"
    diff12 = jsondiffpatch.diff(text2, text1)
    diff13 = jsondiffpatch.diff(text3, text1)
    middleResult = jsondiffpatch.unpatch(text1, diff12)
    result = jsondiffpatch.unpatch(middleResult, diff13)
    console.info result, middleResult, diff12, diff13


