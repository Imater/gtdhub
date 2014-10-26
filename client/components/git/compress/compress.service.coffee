'use strict'

angular.module('gtdhubApp').service 'CompressService', ()->
  class CompressService
    constructor: (method = 'LZString') ->
      @method = method
    compress: (blob)->
      @realization[@method].compress(blob)
    decompress: (blob)->
      @realization[@method].decompress(blob)
    realization:
      LZString:
        compress: (blob) ->
          LZString.compressToUTF16 blob
        decompress: (blob) ->
          LZString.decompressFromUTF16 blob if blob
      Pako:
        compress: (blob) ->
          binaryString = pako.deflate blob, {level: 6, to: 'string', gzip: false}
        decompress: (blob) ->
          restored = pako.inflate blob, {to: 'string'}
      PakoGzip:
        compress: (blob) ->
          binaryString = pako.deflate blob, {level: 1, to: 'string', gzip: true}
        decompress: (blob) ->
          restored = pako.inflate blob, {to: 'string'}
