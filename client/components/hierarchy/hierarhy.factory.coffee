'use strict'
angular.module('gtdhubApp').factory 'Hierarhy', ->
  # AngularJS will instantiate a singleton by calling 'new' on this function
  class Hierarchy
    constructor: ()->
      @childs = []
      @path = []
      @level = 0
    addChild: (child) ->
      @childs.push child
      child.level = @level + 1
      @parents = [] if !@parents
      child.parent = @
      #child.path = @path.concat [@child.title]
      child
    getFind: (answer = [], mapFn)->
      answer.push result if mapFn and (result = mapFn(@))
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
