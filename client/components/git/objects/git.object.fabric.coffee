'use strict'

angular.module('gtdhubApp').service 'GitObject', (ShaService)->
  class GitObject
    needCompress: false
    constructor: (jsonBlob)->
      stringifyBlob = JSON.stringify jsonBlob
      @hash = ShaService.sha(stringifyBlob)
      if @needCompress
        blob = LZString.compressToUTF16 stringifyBlob
      else
        blob = stringifyBlob
      @blob = blob
    get: ()->
      if @needCompress
        JSON.parse LZString.decompressFromUTF16 @blob if @blob
      else
        JSON.parse @blob if @blob
    decompress: (blob)->
      if new GitObject().needCompress
        JSON.parse LZString.decompressFromUTF16 blob if blob
      else
        JSON.parse blob if blob

