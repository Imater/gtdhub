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
            thisDir.push
              rights: @rights
              type: "tree"
              hash: @_getTree(value)
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
      console.info commitObject
      @_restoreTree(commitObject.tree, outputTree)
    _restoreTree: (treeHash)->
      outputTree = []
      tree = @gitStorage.get treeHash
      treeObjects = new GitTree().getObjects tree
      for object in treeObjects
        newElement = {}
        nameField = JSON.parse object.name
        if object.type == 'blob'
          newElement = nameField
          objectString = @gitStorage.get object.hash
          keyValues = new GitObject().getObject objectString
          for key, value of keyValues
            newElement[key] = value
        else
          newElement[nameField] = @_restoreTree object.hash
          console.info 'folder', newElement
        outputTree.push newElement
      outputTree





