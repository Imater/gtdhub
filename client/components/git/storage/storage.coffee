'use strict'

angular.module('gitStorage').service 'GitStorage', (CompressService, GitDiff, GitPack)->
  class GitStorage
    constructor: (storageName)->
      @storageName = storageName
      @storage = {}
      @compressService = new CompressService('LZString')
      #@compressService = new CompressService('None')
      #@compressService = new CompressService('PakoGzip')
      @delay = 30
      #@compressService = new CompressService('None')
    setAsync: (key, value, cb)->
      self = @
      allkey = @storageName + key
      val = self.compressService.compress value
      localStorage.setItem allkey, val
      self.storage[allkey+"!"] = value
      cb null
    getAsync: (key, cb)->
      self = @
      allkey = @storageName + key
      if (s = self.storage[allkey])
        cb null, s
        return
      found = localStorage.getItem allkey
      if key and found and found != null
        answer = self.compressService.decompress found
        cb null, answer
      else
        cb null, undefined
    setAsyncTmp: (key, value, cb)->
      self = @
      setTimeout ->
        self.storage[key] = self.compressService.compress value
        cb null
      , self.delay
    getAsyncTmp: (key, cb)->
      self = @
      setTimeout ->
        found = self.storage[key]
        if found
          cb null, self.compressService.decompress found
        else
          cb null, undefined
      , self.delay
    set: (key, value)->
      @storage[key] = @compressService.compress value
    get: (key)->
        found = @storage[key]
        if found
          @compressService.decompress found
    length: ()->
      (JSON.stringify @storage).length
    delete: (key, cb)->
      self = @
      allkey = @storageName + key
      delete self.storage[allkey]
      localStorage.removeItem allkey
      cb null
