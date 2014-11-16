'use strict'

angular.module('gitStorage').service 'GitStorage', (CompressService, GitDiff, GitPack)->
  class GitStorage
    constructor: (storageName)->
      @storageName = storageName
      @storage = {}
      @compressService = new CompressService('LZString')
      #@compressService = new CompressService('None')
      #@compressService = new CompressService('PakoGzip')
      @compressService = new CompressService('None')
    set: (key, value)->
      @storage[key] = @compressService.compress value
    get: (key)->
        found = @storage[key]
        if found
          @compressService.decompress found
    length: ()->
      (JSON.stringify @storage).length
    delete: (key)->
      delete @storage[key]
