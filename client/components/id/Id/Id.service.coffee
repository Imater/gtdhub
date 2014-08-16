'use strict'

angular.module('gtdhubApp').factory 'Id', ->
  class Id
    instance = null
    class PrivateClass
      constructor: ()->
        @id = 1
    @get: ()->
      instance ?= new PrivateClass
      instance.id++
