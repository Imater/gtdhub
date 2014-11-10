'use strict'

angular.module('gitStorage').service 'GitStorage', ()->
  class GitStorage
    constructor: (storageName)->
      @storageName = storageName
      @storage = {}
    set: (key, value)->
      @storage[key] = value
    get: (key)->
      @storage[key]
    length: ()->
      (JSON.stringify @storage).length
