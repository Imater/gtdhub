'use strict'
angular.module('gtdhubApp').factory 'Storage', ->
  class Storage
    constructor: (name)->
      @name = name
      @data = {}
    add: (model)->
      modelData = model.get()
      @data[modelData._id] = modelData
    count: ->
      if @data then Object.keys(@data).length else 0

