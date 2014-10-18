'use strict'

angular.module('gtdhubApp').service 'GitService', (ShaService, GitObject, Traverse)->
  class GitService
    constructor: ()->
      @objects = {}
      @refs = {}
    init: ()->
      @objects = {}
    addObject: (object)->
      newObject = new GitObject object
      @objects[newObject.hash] = newObject.blob
      newObject
    getObject: (hash)->
      @objects[hash].get() if @objects[hash]

    add: (object)->
      addedObject = @addObject(object.blob)
      tree =
        type: object.type
        hash: addedObject.hash
      @addObject(tree)
    commit: (oldTree, title)->
      self = @
      oldHashes = Object.keys(oldTree.objects)
      newHashes = Object.keys(@objects)
      diff = _.difference(newHashes, oldHashes)
      commit =
        type: "commit"
        title: title
        author: "Imater"
        committer: "Git"
        time: new Date().getTime()
        hash: "jj"
      @addObject commit
    makeTree: (tree)->
      self = @
      traverse = new Traverse(tree)
      result = traverse.reduce (acc, x) ->
        if (@isLeaf)
          acc.push(x)
        acc
      , []

      _.each result, (value, key)->
        self.add({type: key, blob: value});
      console.info JSON.stringify result, null, "\t"
      return result

    addTree: (tree)->
      self = @
      gitTree = []
      _.each tree, (value, key)->
        isTree = _.isObject(value)
        if isTree
          gitTree.push { t: "tree", hash: self.addTree(value), n: key, array: _.isArray(value) }
        else
          newObject = self.addObject JSON.stringify value
          gitTree.push { t: "blob", hash: newObject.hash, n: key }

      treeObject = new GitObject JSON.stringify gitTree
      self.addObject JSON.stringify gitTree
      treeObject.hash

    addCommit: (hash, message)->
      commit =
        message: message
        tree: hash
        parent: @refs["HEAD"]
      commitObject = @addObject JSON.stringify commit
      @refs["HEAD"] = commitObject.hash


    restoreTree: (theClass = {}, hash, tree = {}, array)->
      self = @
      if array
        tree = []
      else
        tree = new theClass
      this_tree = JSON.parse @objects[hash]
      _.each this_tree, (value, key)->
        if value.t == "blob"
          tree[value.n] = JSON.parse self.objects[value.hash]
        else if value.t == "tree"
          if array
            tree.push self.restoreTree(theClass, value.hash, tree, value.array)
          else
            tree[value.n] = {} if !tree[value.n]
            tree[value.n] = self.restoreTree(theClass, value.hash, tree, value.array)

      return tree


