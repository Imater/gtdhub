'use strict'

angular.module('gtdhubApp').factory 'Task', (Hierarhy) ->
  class Task extends Hierarhy
    constructor: (params)->
      super
      @title = params.title
