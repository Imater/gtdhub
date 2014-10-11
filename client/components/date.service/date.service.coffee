'use strict'
angular.module('gtdhubApp').service 'DateService', ->
  class DateService
    constructor: ()->
      @dateStarte = new Date().getTime()
    now: ()->
      new Date().getTime()

