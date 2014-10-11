'use strict'

angular.module('gtdhubApp').factory 'StoreCommonModel', (ObjectIdService, DateService)->
  class StoreModel
    constructor: (modelName, tree)->
      @data = _.extend({}, @defaultModel, tree)
      @data.modelName = modelName
      @data.dateCreate = new DateService().now()
      @data._id = ObjectIdService().toString() if !tree?._id
      @data.parent_id = 1 if !tree?.parent_id
      @data.order = new DateService().now() if !tree?.order
    set: (tree)->
      @data = _.extend({}, @data, tree)
    get: ->
      @data

