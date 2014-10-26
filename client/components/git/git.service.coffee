'use strict'

angular.module('gtdhubApp').service 'GitService', (ShaService, GitObject, Traverse)->
  class GitService
    constructor: ()->
      @objects = {}
      @refs = {}
      @diffs = {}
    init: ()->
      @objects = {}
    addObject: (object)->
      newObject = new GitObject object
      @objects[newObject.hash] = newObject.blob
      newObject
    getObject: (hash)->
      @decompress(@objects[hash]) if @objects[hash]

    addDiff: (hash, diff)->
      newObject = new GitObject diff
      @diffs[hash] = newObject.blob
      newObject
    getDiff: (hash)->
      @decompress(@objects[hash]) if @objects[hash]

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
        self.add({type: key, blob: value})
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

    addTreeBig: (tree)->
      self = @
      gitTree = []
      _.each tree, (value, key)->
        if key == 'childs' or _.isArray(tree)
          gitTree.push
            type: "tree"
            hash: self.addTreeBig(value)
            #name: JSON.stringify tree.info
            #array: _.isArray(value)
        else if key == 'blob'
          newObject = self.addObject value
          gitTree.push
            type: "blob"
            hash: newObject.hash
            info: JSON.stringify tree.info
            id: tree.info._id
            size: JSON.stringify(tree).length

      treeObject = new GitObject gitTree
      if gitTree.length
        self.addObject gitTree
      treeObject.hash

    addCommit: (hash, message)->
      commit =
        message: message
        tree: hash
        parent: @refs["HEAD"]
      if @objects[@refs["HEAD"]]
        if hash == @decompress(@objects[@refs["HEAD"]]).tree
          return @refs["HEAD"]
      commitObject = @addObject commit
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

    restoreTreeBig: (theClass = {}, hash, tree = {}, array1)->
      self = @
      if array1
        tree = []
      else
        tree = new theClass
      this_tree = self.getObject hash
      _.each this_tree, (value, key)->
        if value.type == "blob"
          tree.blob = self.getObject value.hash
          tree.info = JSON.parse value.info
          tree.id = value.id
        else if value.type == "tree"
          if array1
            s = self.restoreTreeBig(theClass, value.hash, tree, null)
            tree.push s
          else
            tree.childs = {} if !tree.childs
            tree.childs = self.restoreTreeBig(theClass, value.hash, tree, "fuck")

      return tree
    decompress: (blob)->
      new GitObject().decompress(blob)
    getFind: (answer = [], mapFn)->
      answer.push result if mapFn and (result = mapFn(@))
      if @childs
        for child in @childs
          child.getFind(answer, mapFn)
      answer

    mapTree: (hashTree, answer = [], mapFn) =>
      self = @
      treeObject = @getObject(hashTree)
      _.each treeObject, (value)->
        if value.type == 'blob'
          answer.push result if mapFn and (result = mapFn(value))
        else if value.type == 'tree'
          self.mapTree value.hash, answer, mapFn
      answer
    lsTree: (hashHead, answer = []) =>
      commit = @getObject(hashHead)

      @mapTree commit.tree, answer, (blob)->
        { type: blob.type, id: blob.id, size: blob.size, hash: blob.hash }

      if commit.parent
        @lsTree commit.parent, answer
      answer
    gc: () =>
      self = @
      tm = new Date().getTime()
      pad = (a,b) -> return(1e15+a+"").slice(-b)
      result = @lsTree(@refs['HEAD'])
      result = _.sortBy result, (value)->
        value.type + pad(value.id,5) + pad(value.size, 10)
      result = _.uniq result, false, (val)->
        val.hash

      baseObject = ""
      prevId = ""
      _.each result, (val) ->
        if val.id != prevId
          prevId = val.id
          baseObject = self.getObject(val.hash)
        else
          currentObject = self.getObject(val.hash)
          diff = jsondiffpatch.diff(currentObject, baseObject)
          if JSON.stringify(diff).length < self.objects[val.hash].length
            delete self.objects[val.hash] if self.objects[val.hash]
            self.addDiff(val.hash, diff)
          else
            prevId = val.id
            baseObject = self.getObject(val.hash)


      console.info "gc time = " + (new Date().getTime() - tm) + "ms"
      return result
