'use strict'

angular.module('gtdhubApp').service 'ShaService', ()->
  sha = (blob) ->
    blob = "" if !blob
    shaObj = new jsSHA(blob, "TEXT")
    shaObj.getHash("SHA-1", "HEX").substr(0,10)
  return { sha: sha }


