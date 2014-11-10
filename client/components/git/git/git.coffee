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
