'use strict'

angular.module('gitStorage').service 'GitDateTime', ()->
  class GitDateTime
    getDateTime: ()->
      now = new Date()
      now.getTime().toString() + " " + (now.getTimezoneOffset()/60)
    getUTC: (dateTimeString)->
      parseInt dateTimeString.split(" ")[0]
