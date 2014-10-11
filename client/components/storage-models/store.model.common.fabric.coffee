'use strict'

angular.module('gtdhubApp').factory 'StoreCommonModel', (ObjectIdService, DateService)->
  class StoreModel
    constructor: (modelName, tree)->
      @data = _.extend({}, @defaultModel, tree)
      @data.modelName = modelName
      @data.dateCreate = new DateService().now();
      @data._id = new ObjectIdService().toString()
    set: (tree)->
      @data = _.extend({}, @data, tree)
    get: ->
      @data

