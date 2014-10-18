'use strict'
angular.module('gtdhubApp').factory 'Hierarhy', ->
  # AngularJS will instantiate a singleton by calling 'new' on this function
  class Hierarchy
    constructor: ()->
      return
    addChild: (child) ->
      @childs = [] if !@childs
      @childs.push child
      child
    getFind: (answer = [], mapFn)->
      answer.push result if mapFn and (result = mapFn(@))
      if @childs
        for child in @childs
          child.getFind(answer, mapFn)
      answer
    getCount: ()->
      @getFind( [], (el)->
        el.id
      ).length
    getPath: (parents = [])->
      if @parent
        parents.push @parent.title
        @parent.getPath parents
      parents
