#
#*
#* Copyright (c) 2011 Justin Dearing (zippy1981@gmail.com)
#* Dual licensed under the MIT (http://www.opensource.org/licenses/mit-license.php)
#* and GPL (http://www.opensource.org/licenses/gpl-license.php) version 2 licenses.
#* This software is not distributed under version 3 or later of the GPL.
#*
#* Version 1.0.1-dev
#*
#

###*
Javascript class that mimics how WCF serializes a object of type MongoDB.Bson.ObjectId
and converts between that format and the standard 24 character representation.
###
'use strict'
angular.module('gtdhubApp').service 'ObjectIdService', ->
  ObjectId = (->
    increment = 0
    # Just always stick the value in.
    ObjId = ->
      return new ObjectId(arguments[0], arguments[1], arguments[2], arguments[3]).toString()  unless this instanceof ObjectId
      if typeof (arguments[0]) is "object"
        @timestamp = arguments[0].timestamp
        @machine = arguments[0].machine
        @pid = arguments[0].pid
        @increment = arguments[0].increment
      else if typeof (arguments[0]) is "string" and arguments[0].length is 24
        @timestamp = Number("0x" + arguments[0].substr(0, 8))
        @machine = Number("0x" + arguments[0].substr(8, 6))
        @pid = Number("0x" + arguments[0].substr(14, 4))
        @increment = Number("0x" + arguments[0].substr(18, 6))
      else if arguments.length is 4 and arguments[0]?
        @timestamp = arguments[0]
        @machine = arguments[1]
        @pid = arguments[2]
        @increment = arguments[3]
      else
        @timestamp = Math.floor(new Date().valueOf() / 1000)
        @machine = machine
        @pid = pid
        @increment = increment++
        increment = 0  if increment > 0xffffff
      return
    pid = Math.floor(Math.random() * (32767))
    machine = Math.floor(Math.random() * (16777216))
    unless typeof (localStorage) is "undefined"
      mongoMachineId = parseInt(localStorage["mongoMachineId"])
      machine = Math.floor(localStorage["mongoMachineId"])  if mongoMachineId >= 0 and mongoMachineId <= 16777215
      localStorage["mongoMachineId"] = machine
      document.cookie = "mongoMachineId=" + machine + ";expires=Tue, 19 Jan 2038 05:00:00 GMT"
    else
      cookieList = document.cookie.split("; ")
      for i of cookieList
        cookie = cookieList[i].split("=")
        if cookie[0] is "mongoMachineId" and cookie[1] >= 0 and cookie[1] <= 16777215
          machine = cookie[1]
          break
      document.cookie = "mongoMachineId=" + machine + ";expires=Tue, 19 Jan 2038 05:00:00 GMT"
    ObjId
  )()
  ObjectId::getDate = ->
    new Date(@timestamp * 1000)

  ObjectId::toArray = ->
    strOid = @toString()
    array = []
    i = undefined
    i = 0
    while i < 12
      array[i] = parseInt(strOid.slice(i * 2, i * 2 + 2), 16)
      i++
    array


  ###*
  Turns a WCF representation of a BSON ObjectId into a 24 character string representation.
  ###
  ObjectId::toString = ->
    timestamp = @timestamp.toString(16)
    machine = @machine.toString(16)
    pid = @pid.toString(16)
    increment = @increment.toString(16)
    "00000000".substr(0, 8 - timestamp.length) + timestamp + "000000".substr(0, 6 - machine.length) + machine + "0000".substr(0, 4 - pid.length) + pid + "000000".substr(0, 6 - increment.length) + increment

  return ObjectId
