'use strict'

angular.module('gitStorage').service 'GitStorage', (CompressService, GitDiff, GitPack)->
  class GitStorage
    constructor: (storageName)->
      @storageName = storageName
      @storage = {}
      @storagePack = {}
      @compressService = new CompressService('LZString')
      #@compressService = new CompressService('None')
      #@compressService = new CompressService('PakoGzip')
      @compressService = new CompressService('None')
    set: (key, value)->
      if !@_getPacked key
        @storage[key] = @compressService.compress value
    get: (key)->
      storage = @_getPacked key
      if !storage
        storage = @storage[key]
        if storage
          return @compressService.decompress storage
      else
        return storage
    length: ()->
      (JSON.stringify @storage).length + (JSON.stringify @storagePack).length
    pack: (currentHash, baseHash) ->
      current = @get currentHash
      base = @get baseHash
      gitDiff = new GitDiff()
      patch = gitDiff.patchMake base, current
      @_setPacked currentHash, patch, baseHash, base
      patch
    _setPacked: (hash, patch, baseHash, base) ->
      pack = new GitPack
        hash: hash
        type: 'type'
        size: 77
        deep: 1
        baseHash: baseHash
        diff: patch
      packString = pack.getString()
      @storagePack[hash] = @compressService.compress packString
      delete @storage[hash]
      if !@storagePack[baseHash]
        pack = new GitPack
          hash: hash
          type: 'type2'
          size: 88
          blob: base
        @storagePack[baseHash] = @compressService.compress pack.getString()
        delete @storage[baseHash]
    _getPacked: (hash) ->
      foundPack = @storagePack[hash]
      return undefined if !foundPack

      packString = @compressService.decompress foundPack
      packObject = new GitPack().get(packString)
      if packObject.diff
        base = @get packObject.baseHash
        console.info 'TRUBLE!!!!', packObject.baseHash, base, JSON.stringify @, null, "  " if !base
        gitDiff = new GitDiff()
        return gitDiff.patchApply base, packObject.diff
      else
        return packObject.blob
