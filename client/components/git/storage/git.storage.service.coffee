'use strict'

angular.module('gitStorage').service 'GitStorage', (CompressService)->
  class GitStorage
    constructor: (storageName)->
      @storageName = storageName
      @storage = {}
      @compressService = new CompressService("LZString")
    set: (key, value)->
      @storage[key] = @compressService.compress value
    get: (key)->
      @compressService.decompress @storage[key]
    length: ()->
      (JSON.stringify @storage).length
