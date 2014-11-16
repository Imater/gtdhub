'use strict'

angular.module('gitStorage').service 'GitDiff', ()->
  class GitDiff
    constructor: (diffToolName = 'DiffMatchPatch') ->
      #
    patchMake: (text1, text2) ->
      vcd = new diffable.Vcdiff()
      vcd.blockSize = 3
      delta = vcd.encode text1, text2
      delta
    patchApply: (text1, patch) ->
      vcd = new diffable.Vcdiff()
      vcd.decode text1, patch
