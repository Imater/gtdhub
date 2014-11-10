'use strict'

angular.module('gitStorage').service 'GitTree', (CompressService, GitSha)->
  class GitTree
    constructor: (treeObjects)->
      self = @
      @tree = ""
      _.each treeObjects, (el, key)->
        self.tree +=
          "#{el.rights}\t"+
          "#{el.type}\t"+
          "#{el.hash}\t"+
          "#{el.name}\n"
    getString: ()->
      @tree
    getHash: ()->
      GitSha.sha @tree
    getObjects: ()->
      objects = []
      lines = @tree.split("\n")
      _.each lines, (line, key) ->
        cols = line.split("\t")
        objects.push
          rights: cols[0]
          type: cols[1]
          hash: cols[2]
          name: cols[3]
      objects
