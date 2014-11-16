'use strict'

angular.module('gitStorage').service 'Git', (GitStorage, GitTree, GitObject, GitCommit, GitDateTime)->
  class Git
    constructor: (gitName)->
      @gitStorage = new GitStorage(gitName)
      @gitStorageRef = new GitStorage("#{gitName} ref")
      @rights = "i"
    status: (tree)->
      @_getTree(tree)
    commit: (treeHash, text)->
      @_commit(treeHash, text)
    log: ()->
      head = @gitStorageRef.get 'HEAD'
      @_log(head)
    checkout: (commitHash)->
      @_checkout(commitHash)
    gc: ()->
      @_gc()
    _log: (head, log = [])->
      commit = @gitStorage.get head
      commitObject = new GitCommit().getObject(commit)
      log.push { hash: head, commit: commitObject }
      if commitObject.parent
        @_log commitObject.parent, log
      else
        return log
    _commit: (treeHash, text)->
      headCommit = @gitStorageRef.get 'HEAD'
      dir =
        tree: treeHash
        parent: headCommit
        author: "@imater"
        date: new GitDateTime().getDateTime()
        message: text
      gitCommit = new GitCommit dir
      commitObject = new GitObject gitCommit.getString()
      if headCommit != commitObject.hash
        @gitStorage.set commitObject.hash, commitObject.blob
        @gitStorageRef.set 'HEAD', commitObject.hash
      commitObject.hash
    _getTree: (tree)->
      thisDir = []
      for index, element of tree
        newBlob = {}
        newName = {}
        for key, value of element
          if _.isArray(value)
            subTree = @_getTree value
            thisDir.push
              rights: @rights
              type: "tree"
              hash: subTree
              size: 0
              name: JSON.stringify key
          else if key[0] == "_"
            newName[key] = value
          else
            newBlob[key] = value
        if Object.keys(newBlob).length
          newObject = new GitObject(newBlob)
          @gitStorage.set newObject.hash, newObject.blob
          thisDir.push
            rights: @rights
            type: "blob"
            hash: newObject.hash
            size: newObject.blob.length
            name: JSON.stringify newName
      if thisDir.length
        gitTree = new GitTree(thisDir)
        gitObject = new GitObject gitTree.getString()
        @gitStorage.set gitObject.hash, gitObject.blob
        gitObject.hash
    _checkout: (commitHash)->
      outputTree = []
      commit = @gitStorage.get commitHash
      commitObject = new GitCommit().getObject(commit)
      @_restoreTree(commitObject.tree, outputTree)
    _restoreTree: (treeHash)->
      outputTree = []
      tree = @gitStorage.get treeHash
      treeObjects = new GitTree().getObjects tree
      lastTree = undefined
      for object in treeObjects
        newElement = {}
        nameField = JSON.parse object.name
        if object.type == 'tree'
          lastTree =
            key: nameField
            value: @_restoreTree object.hash
        else if object.type == 'blob'
          newElement = nameField
          objectString = @gitStorage.get object.hash
          keyValues = new GitObject().getObject objectString
          for key, value of keyValues
            newElement[key] = value
          if lastTree
            newElement[lastTree.key] = lastTree.value
            lastTree = undefined
        if Object.keys(newElement).length
          outputTree.push newElement
      outputTree
    _mapTree: (hashTree, answer = [], mapFn)->
      treeString = @gitStorage.get hashTree
      treeObject = new GitTree().getObjects(treeString)
      answer.push
        type: 'tree'
        hash: hashTree
        size: treeString.length
      for element in treeObject
        if element.type == 'tree'
          @_mapTree(element.hash, answer, mapFn)
        else if element.type == 'blob'
          answer.push result if mapFn and (result = mapFn(element))
      answer
    _lsTree: (commitHash, answer = [])->
      commitString = @gitStorage.get commitHash
      commitObject = new GitCommit().getObject(commitString)
      mapFn = (blob)->
        type: blob.type
        hash: blob.hash
        _id: (JSON.parse blob.name)?._id
        size: blob.size
      answer.push
        type: 'commit'
        hash: commitHash
        size: commitString.length

      @_mapTree commitObject.tree, answer, mapFn
      if commitObject.parent
        @_lsTree commitObject.parent, answer
      answer
    _pad: (a,b) -> return(1e15+a+"").slice(-b)
    _gc: ()->
      self = @
      headHash = @gitStorageRef.get 'HEAD'
      allHistoryBlobs = @_lsTree(headHash)
      answerDistinct = _.uniq allHistoryBlobs, false, (val)->
        val.hash
      answer = _.sortBy answerDistinct, (element)->
        self._pad(element.type, 10) +
        self._pad(element._id, 10) +
        self._pad(element.size, 10)
      .reverse()
      @_moveToPack(answer)
    _moveToPack: (objects) ->
      prevHash = undefined
      prevType = undefined
      for object in objects
        if prevHash and object.type == prevType
          @gitStorage.pack object.hash, prevHash
        prevHash = object.hash
        prevType = object.type






