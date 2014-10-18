'use strict'

angular.module('gtdhubApp').service 'GitObject', (ShaService)->
  class GitObject
    constructor: (jsonBlob)->
      blob = jsonBlob
      @blob = blob
      @hash = ShaService.sha(blob)
    get: ()->
      @blob if @blob
