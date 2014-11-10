'use strict'

angular.module('gitStorage').service 'GitObject', (GitSha, CompressService)->
  class GitObject
    needCompress: false
    constructor: (jsonBlob)->
      stringifyBlob = jsonBlob
      if _.isObject jsonBlob
        stringifyBlob = JSON.stringify jsonBlob
      @hash = GitSha.sha(stringifyBlob)
      if @needCompress
        compressService = new CompressService("LZString")
        blob = compressService.compress(stringifyBlob)
      else
        blob = stringifyBlob
      @blob = blob
    get: ()->
      if @needCompress
        compressService = new CompressService("LZString")
        answer = compressService.decompress @blob if @blob
      else
        answer = @blob if @blob
      if answer and answer[0] == '{'
        answer = JSON.parse answer
      answer
    decompress: (blob)->
      if new GitObject().needCompress
        JSON.parse LZString.decompressFromUTF16 blob if blob
      else
        JSON.parse blob if blob

