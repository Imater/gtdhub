'use strict'

angular.module('gitStorage').service 'GitSha', ()->
  sha = (blob) ->
    blob = "" if !blob
    shaObj = new jsSHA(blob, "TEXT")
    shaObj.getHash("SHA-1", "HEX").substr(0,40)
  return { sha: sha }


