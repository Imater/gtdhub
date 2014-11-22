'use strict'

angular.module('gitStorage').service 'Git', (GitStorage, GitTree, GitObject, GitCommit, GitDateTime, GitDiff, GitPack)->
  class Git
    constructor: (gitName)->
      gitName = "gitDB " if !gitName
      @gitStorage = new GitStorage(gitName)
      @gitStorageRef = new GitStorage("#{gitName} REF ")
      @gitStoragePack = new GitStorage("#{gitName} PACK ")
      @rights = "i"
    status: (tree, cb)->
      @_getTree tree, (err, treeHash)->
        cb err, treeHash
    log: (cb)->
      self = @
      @gitStorageRef.getAsync 'HEAD', (err, head) ->
        self._log head, cb
    get: (key, cb)->
      self = @
      @_getPacked key, (err, storagePacked) ->
        if !storagePacked
          self.gitStorage.getAsync key, (err, storage) ->
            if storage
              cb err, storage
            else
              console.info "not found in last place :(", key
        else
          cb err, storagePacked
    pack: (currentHash, baseHash, cb) ->
      self = @
      @get currentHash, (err, current) ->
        self.get baseHash, (err, base) ->
          if base
            gitDiff = new GitDiff()
            patch = gitDiff.patchMake base, current
            self._setPacked currentHash, patch, baseHash, base, current, (err, isCandidateBad)->
              cb err, patch, isCandidateBad
          else
            console.info "NOT FOUND BASE :(", baseHash
    _setPacked: (hash, patch, baseHash, base, current, cb) ->
      self = @
      pack = new GitPack
        hash: hash
        type: '1'
        size: 77
        deep: 1
        baseHash: baseHash
        diff: patch
      packString = pack.getString()
      if packString.length + 10 >= base.length or false
        self._saveBase hash, baseHash, base, (err)->
          cb null, "bad candidate"
      else
        #console.info "good base #{hash}, #{baseHash} patch=#{packString.length}, base = #{base.length}, current = #{current.length}",
        #console.info "patch", pack.getString()
        self.gitStoragePack.setAsync hash, packString, (err)->
          self.gitStorage.delete hash, (err)->
             self.gitStoragePack.getAsync baseHash, (err, oldBase)->
                if !oldBase
                  self._saveBase hash, baseHash, base, (err)->
                    cb err
                else
                  cb err
    _saveBase: (hash, baseHash, base, cb)->
      self = @
      pack = new GitPack
        hash: hash
        type: '2'
        size: base.length
        blob: base
      self.gitStoragePack.setAsync baseHash, pack.getString(), (err)->
        self.gitStorage.delete baseHash, (err)->
          cb err
    _getPacked: (hash, cb) ->
      self = @
      @gitStoragePack.getAsync hash, (err, foundPack)->
        if !foundPack
          cb err, undefined
        else
          packObject = new GitPack().get(foundPack)
          if packObject.diff
            self.getAsync packObject.baseHash, (err, base) ->
              gitDiff = new GitDiff()
              cb err, gitDiff.patchApply base, packObject.diff
          else
            cb err, packObject.blob

    _log: (head, cb, log = [])->
      self = @
      @gitStorage.getAsync head, (err, commit)->
        commitObject = new GitCommit().getObject commit
        log.push { hash: head, commit: commitObject }
        if commitObject.parent
          self._log commitObject.parent, (err, fn)->
            cb err, log
          , log
        else
          cb err, log
    commit: (treeHash, text, cb)->
      self = @
      @gitStorageRef.getAsync 'HEAD', (err, headCommit) ->
        dir =
          tree: treeHash
          parent: headCommit
          author: "@imater"
          date: new GitDateTime().getDateTime()
          message: text
        gitCommit = new GitCommit dir
        commitObject = new GitObject gitCommit.getString()
        if headCommit != commitObject.hash
          self.gitStorage.setAsync commitObject.hash, commitObject.blob, (err) ->
            self.gitStorageRef.setAsync 'HEAD', commitObject.hash, (err) ->
              cb err, commitObject.hash
    _getTree: (tree, cb)->
      self = @
      thisDir = []
      async.each Object.keys(tree), (index, cb) ->
        element = tree[index]
        newBlob = {}
        newName = {}
        async.each Object.keys(element), (key, callback) ->
          value = element[key]
          if _.isArray(value)
            self._getTree value, (err, subTree) ->
              thisDir.push
                rights: self.rights
                type: "tree"
                hash: subTree
                size: 0
                name: JSON.stringify key
              callback()
          else if key[0] == "_"
            newName[key] = value
            callback()
          else
            newBlob[key] = value
            callback()
        , (err) ->
          if Object.keys(newBlob).length
            newObject = new GitObject(newBlob)
            thisDir.push
              rights: self.rights
              type: "blob"
              hash: newObject.hash
              size: newObject.blob.length
              name: JSON.stringify newName
            self.gitStorage.setAsync newObject.hash, newObject.blob, (err)->
              cb err
          else
            cb()
      , (err) ->
        if thisDir.length
          gitTree = new GitTree(thisDir)
          gitObject = new GitObject gitTree.getString()
          self.gitStorage.setAsync gitObject.hash, gitObject.blob, (err)->
            cb err, gitObject.hash
    checkout: (commitHash, cb) ->
      self = @
      commit = @gitStorage.getAsync commitHash, (err, commit) ->
        commitObject = new GitCommit().getObject commit
        self._restoreTree commitObject.tree, [], cb
    _restoreTree: (treeHash, outputTree, cb)->
      self = @
      outputTree = []
      tree = @gitStorage.getAsync treeHash, (err, tree) ->
        treeObjects = new GitTree().getObjects tree
        lastTree = undefined
        async.eachSeries treeObjects, (object, callback)->
          newElement = {}
          nameField = JSON.parse object.name
          if object.type == 'tree'
            self._restoreTree object.hash, outputTree, (err, value) ->
              lastTree =
                key: nameField
                value: value
              callback err
          else if object.type == 'blob'
            newElement = nameField
            self.gitStorage.getAsync object.hash, (err, objectString) ->
              keyValues = new GitObject().getObject objectString
              for key, value of keyValues
                newElement[key] = value
              if lastTree
                newElement[lastTree.key] = lastTree.value
                lastTree = undefined
              if Object.keys(newElement).length
                outputTree.push newElement
              callback err
        , (err) ->
          cb null, outputTree
    _mapTree: (hashTree, answer = {}, mapFn, cb)->
      self = @
      self.gitStorage.getAsync hashTree, (err, treeString) ->
        treeObject = new GitTree().getObjects(treeString)
        if answer[hashTree]
          cb err, answer
        else
          answer[hashTree] =
            type: 'tree'
            hash: hashTree
            size: treeString.length
          async.each treeObject, (element, callback) ->
            if element.type == 'tree'
              self._mapTree element.hash, answer, mapFn, (err, answer)->
                callback()
            else if element.type == 'blob'
              answer[element.hash] = result if mapFn and (result = mapFn(element))
              callback()
          , (err)->
            cb err, answer
    _lsTree: (commitHash, cb, answer = {})->
      self = @
      @gitStorage.getAsync commitHash, (err, commitString) ->
        commitObject = new GitCommit().getObject(commitString)
        mapFn = (blob)->
          type: blob.type
          hash: blob.hash
          _id: (JSON.parse blob.name)?._id
          size: blob.size
        answer[commitHash] =
          type: 'commit'
          hash: commitHash
          size: commitString.length

        self._mapTree commitObject.tree, answer, mapFn, (err, ans) ->
          if commitObject.parent
            self._lsTree commitObject.parent, (err, ans) ->
              cb err, ans
            , answer
          else
            cb err, answer
    _pad: (a,b) -> return(1e15+a+"").slice(-b)
    gc: (cb)->
      self = @
      @gitStorageRef.getAsync 'HEAD', (err, headHash) ->
        self._lsTree headHash, (err, allHistoryBlobs) ->
          all = []
          for key, el of allHistoryBlobs
            all.push el
          answer = _.sortBy all, (element)->
            self._pad(element.type, 10) +
            self._pad(element._id, 10) +
            self._pad(element.size, 10)
          .reverse()
          self._moveToPack answer, (err) ->
            cb err
    _moveToPack: (objects, cb) ->
      self = @
      prevHash = undefined
      prevType = undefined
      async.eachSeries objects, (object, callback) ->
        if prevHash and object.type == prevType
          self.pack object.hash, prevHash, (err, patch, isCandidateBad)->
            if isCandidateBad
              prevHash = object.hash
              prevType = object.type
            callback()
        else
          prevHash = object.hash
          prevType = object.type
          callback()
      , (err) ->
        cb err






