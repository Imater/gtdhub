'use strict'

angular.module('gitStorage').service 'GitObject', (GitSha, CompressService)->
  class GitObject
    constructor: (jsonBlob)->
      stringifyBlob = jsonBlob
      if _.isObject jsonBlob
        stringifyBlob = JSON.stringify jsonBlob
      @hash = GitSha.sha(stringifyBlob)
      @blob = stringifyBlob
    getObject: (blob)->
      answer = blob if blob
      if answer and answer[0] == '{'
        answer = JSON.parse answer
      answer
    get: ()->
      @getObject @blob
