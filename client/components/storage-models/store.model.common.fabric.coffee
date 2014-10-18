'use strict'

angular.module('gtdhubApp').factory 'StoreCommonModel', (ObjectIdService, DateService)->
  class StoreModel
    constructor: (modelName, newData)->
      @data = _.extend({}, @defaultModel, newData)
      @data.modelName = modelName
      @data.dateCreate = new DateService().now()
      @data._id = ObjectIdService().toString() if !newData?._id
      @data.parent_id = 1 if !newData?.parent_id
      @data.order = new DateService().now() if !newData?.order
    set: (newData)->
      @data = _.extend({}, @data, newData)
    get: ->
      @data

