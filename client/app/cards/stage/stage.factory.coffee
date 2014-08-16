'use strict'

angular.module('gtdhubApp').factory 'Stage', (Hierarhy, Id) ->
  # AngularJS will instantiate a singleton by calling 'new' on this function
  class Stage extends Hierarhy
    constructor: (values) ->
      super
      @title = values.title || 'To-do'
      @treeId = values.treeId || '1'
      @id = Id.get()
    addTask: (task)->
      @tasks = [] if !@tasks
      @tasks.push task

  Stage