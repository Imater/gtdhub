'use strict'

angular.module('gitStorage').service 'GitCommit', (GitDateTime)->
  class GitCommit
    constructor: (commitObject)->
      self = @
      @commit = ""
      el = commitObject
      parent = ""
      parent = "parent\t#{el.parent}\n" if el.parent
      if el.date
        date = el.date
      else
        date = new GitDateTime().getDateTime()
      self.commit += "
        tree\t#{el.tree}\n"+
        "#{parent}"+
        "author\t#{el.author}\n"+
        "date\t#{date}\n"+
        "message\t#{el.message}"
    getString: ()->
      @commit
    getObject: ()->
      object = {}
      lines = @commit.split("\n")
      _.each lines, (line) ->
        cols = line.split("\t")
        object[cols[0]] = cols[1]
      object

