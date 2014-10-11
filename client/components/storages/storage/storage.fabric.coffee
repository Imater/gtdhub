'use strict'
angular.module('gtdhubApp').factory 'Storage', ->
  class Storage
    constructor: (name)->
      @name = name
      @dataById = {}
      @dataByParentId = {}
    add: (model)->
      modelData = model.get()
      @dataById[modelData._id] = modelData if modelData?._id
      if modelData?.parent_id
        @dataByParentId[modelData.parent_id] = [] if !@dataByParentId[modelData.parent_id]
        @dataByParentId[modelData.parent_id].push modelData
    count: ->
      if @dataById then Object.keys(@dataById).length else 0
    mapReduce: (mapFn, reduceFn, memo = []) ->
      results = []
      _.each @dataById, (value, key)->
        if mapFn and (result = mapFn(key, value))
          results.push value
      if reduceFn
        _.each results, (value, key)->
          memo = reduceFn(memo, value)
        return memo
      results
    getById: (_id)->
      @dataById[_id]
    getByParentId: (parent_id, orderFn)->
      result = @dataByParentId[parent_id]
      if orderFn
        result = _.sortBy(result, orderFn)
      else
        result

