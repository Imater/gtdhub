'use strict'
angular.module('gtdhubApp').factory 'Storage', ->
  class Storage
    constructor: (name)->
      @name = name
