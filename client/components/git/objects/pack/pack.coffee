'use strict'

angular.module('gitStorage').service 'GitPack', ()->
  class GitPack
    constructor: (packObject)->
      @pack = packObject
    getString: ()->
      diff = JSON.stringify @pack.diff
      if !@pack.baseHash
        packString =
          "#{@pack.type}\t" +
          "#{@pack.size}\n" +
          "#{@pack.blob}"
      else if @pack.diff
        diff = JSON.stringify @pack.diff
        packString =
          "#{@pack.type}\t" +
          "#{@pack.size}\t" +
          "#{@pack.deep}\t" +
          "#{@pack.baseHash}\n" +
          "#{diff}"
      packString
    get: (packString) ->
      col = packString.split("\n")
      firstLineCol = col[0].split "\t"
      if !firstLineCol[3]
        pack =
          type: firstLineCol[0]
          size: parseInt firstLineCol[1]
          blob: col[1]
      else
        pack =
          type: firstLineCol[0]
          size: parseInt firstLineCol[1]
          deep: parseInt firstLineCol[2]
          baseHash: firstLineCol[3]
          diff: JSON.parse col[1]
      pack


