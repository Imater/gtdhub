'use strict'
angular.module('gtdhubApp').service 'StorageService', ->
  class StorageService
    constructor: (name)->
      @name = name
