'use strict'

angular.module('gitStorage').service 'GitObject', (GitSha, CompressService)->
  class GitObject
    needCompress: true
    constructor: (jsonBlob)->
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
        JSON.parse compressService.decompress @blob if @blob
      else
        JSON.parse @blob if @blob
    decompress: (blob)->
      if new GitObject().needCompress
        JSON.parse LZString.decompressFromUTF16 blob if blob
      else
        JSON.parse blob if blob

