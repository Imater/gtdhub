'use strict'
angular.module('gtdhubApp').service 'SyncToServer', ->
  class SyncToServer
    constructor: ()->
      @hello = "hello"
    syncNow: ->
      return @lastSyncTime()

    lastSyncTime: ->
      1413009570980
