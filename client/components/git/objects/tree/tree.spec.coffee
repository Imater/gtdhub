'use strict'

describe 'Git tree', ->

  # load the controller's module
  beforeEach module('gitStorage')

  GitTree = undefined
  GitObject = undefined
  beforeEach inject (_GitTree_) ->
    GitTree = _GitTree_

  it 'exist task model', ->
    expect(GitTree).toBeDefined()

  it 'convert tree to and back', ->
    dir = [
      rights: "imater;valentina"
      type: "blob"
      hash: "dfs3343fdfd232"
      size: 1000
      name: "text.txt"
    ,
      rights: "imater;valentina"
      type: "blob"
      hash: "d3s3343fdfd232"
      size: 1001
      name: "text2.txt"
    ,
      rights: "imater"
      type: "blob"
      hash: "dfs3343fdfd232"
      size: 1002
      name: "text.txt"
    ]
    gitTree = new GitTree(dir)
    for keyName of dir[0]
      expect(gitTree.getObjects(gitTree.getString())[0][keyName]).toBe dir[0][keyName]
    oldLength = JSON.stringify(dir).length
    expect(oldLength).toBeGreaterThan gitTree.tree.length



