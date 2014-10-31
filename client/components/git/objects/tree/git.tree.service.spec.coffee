'use strict'

describe 'Git tree', ->

  # load the controller's module
  beforeEach module('gitStorage')

  GitTree = undefined
  GitObject = undefined
  beforeEach inject (_GitTree_, _GitObject_) ->
    GitTree = _GitTree_
    GitObject = _GitObject_

  it 'exist task model', ->
    expect(GitTree).toBeDefined()

  it 'save blob to object', ->
    dir = [
      rights: "imater;valentina"
      type: "blob"
      hash: "dfs3343fdfd232"
      name: "text.txt"
    ,
      rights: "imater;valentina"
      type: "blob"
      hash: "d3s3343fdfd232"
      name: "text2.txt"
    ,
      rights: "imater"
      type: "blob"
      hash: "dfs3343fdfd232"
      name: "text.txt"
    ]
    t = Date.now()
    gitTree = undefined
    length = 0
    length2 = 0
    for [0..10]
      gitTree = new GitTree(dir)
      length += gitTree.getString().length
      o = new GitObject(gitTree.getString())
      length2 += o.blob.length
      gitTree.getObjects()
    console.info Date.now() - t + " ms", length, length2
    console.info o





