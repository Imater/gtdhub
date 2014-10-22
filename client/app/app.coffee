'use strict'

angular.module("pmkr.memoize", []).factory "pmkr.memoize", [->
  service = ->
    memoizeFactory.apply this, arguments
  memoizeFactory = (fn) ->
    memoized = ->
      args = [].slice.call(arguments)
      key = JSON.stringify args, (key, value)->
        if key == "parent"
          return "1"
        else
          return value
      return cache[key]  if cache.hasOwnProperty(key)
      cache[key] = fn.apply(this, arguments)
      cache[key]
    cache = {}
    memoized
  service
]

angular.module("pmkr.filterStabilize", ["pmkr.memoize"]).factory "pmkr.filterStabilize", [
  "pmkr.memoize"
  (memoize) ->
    service = (fn) ->
      filter = ->
        args = [].slice.call(arguments)

        # always pass a copy of the args so that the original input can't be modified
        args = angular.copy(args)

        # return the `fn` return value or input reference (makes `fn` return optional)
        filtered = fn.apply(this, args) or args[0]
        filtered
      memoized = memoize(filter)
      memoized
    return service
]

angular.module('gtdhubApp', [
  'ngCookies',
  'ngResource',
  'ngSanitize',
  'pmkr.filterStabilize'
  'btford.socket-io',
  'ui.router',
  'ui.bootstrap'
  'angular-redactor'
]).config ($stateProvider, $urlRouterProvider, $locationProvider, $httpProvider) ->
  $urlRouterProvider
  .otherwise '/cards/tree/'

  $locationProvider.html5Mode true
  $httpProvider.interceptors.push 'authInterceptor'

.factory 'authInterceptor', ($rootScope, $q, $cookieStore, $location) ->
  # Add authorization token to headers
  request: (config) ->
    config.headers = config.headers or {}
    config.headers.Authorization = 'Bearer ' + $cookieStore.get 'token' if $cookieStore.get 'token'
    config

  # Intercept 401s and redirect you to login
  responseError: (response) ->
    if response.status is 401
      $location.path '/login'
      # remove any stale tokens
      $cookieStore.remove 'token'

    $q.reject response

.run ($rootScope, $location, Auth) ->
  # Redirect to login if route requires auth and you're not logged in
  $rootScope.$on '$stateChangeStart', (event, next) ->
    Auth.isLoggedInAsync (loggedIn) ->
      $location.path "/login" if next.authenticate and not loggedIn


# Copyright (c) 2013 Pieroxy <pieroxy@pieroxy.net>
# This work is free. You can redistribute it and/or modify it
# under the terms of the WTFPL, Version 2
# For more information see LICENSE.txt or http://www.wtfpl.net/
#
# For more information, the home page:
# http://pieroxy.net/blog/pages/lz-string/testing.html
#
# LZ-based compression algorithm, version 1.3.3
LZString =

# private property
  _keyStr: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="
  _f: String.fromCharCode
  compressToBase64: (input) ->
    return ""  unless input?
    output = ""
    chr1 = undefined
    chr2 = undefined
    chr3 = undefined
    enc1 = undefined
    enc2 = undefined
    enc3 = undefined
    enc4 = undefined
    i = 0
    input = LZString.compress(input)
    while i < input.length * 2
      if i % 2 is 0
        chr1 = input.charCodeAt(i / 2) >> 8
        chr2 = input.charCodeAt(i / 2) & 255
        if i / 2 + 1 < input.length
          chr3 = input.charCodeAt(i / 2 + 1) >> 8
        else
          chr3 = NaN
      else
        chr1 = input.charCodeAt((i - 1) / 2) & 255
        if (i + 1) / 2 < input.length
          chr2 = input.charCodeAt((i + 1) / 2) >> 8
          chr3 = input.charCodeAt((i + 1) / 2) & 255
        else
          chr2 = chr3 = NaN
      i += 3
      enc1 = chr1 >> 2
      enc2 = ((chr1 & 3) << 4) | (chr2 >> 4)
      enc3 = ((chr2 & 15) << 2) | (chr3 >> 6)
      enc4 = chr3 & 63
      if isNaN(chr2)
        enc3 = enc4 = 64
      else enc4 = 64  if isNaN(chr3)
      output = output + LZString._keyStr.charAt(enc1) + LZString._keyStr.charAt(enc2) + LZString._keyStr.charAt(enc3) + LZString._keyStr.charAt(enc4)
    output

  decompressFromBase64: (input) ->
    return ""  unless input?
    output = ""
    ol = 0
    output_ = undefined
    chr1 = undefined
    chr2 = undefined
    chr3 = undefined
    enc1 = undefined
    enc2 = undefined
    enc3 = undefined
    enc4 = undefined
    i = 0
    f = LZString._f
    input = input.replace(/[^A-Za-z0-9\+\/\=]/g, "")
    while i < input.length
      enc1 = LZString._keyStr.indexOf(input.charAt(i++))
      enc2 = LZString._keyStr.indexOf(input.charAt(i++))
      enc3 = LZString._keyStr.indexOf(input.charAt(i++))
      enc4 = LZString._keyStr.indexOf(input.charAt(i++))
      chr1 = (enc1 << 2) | (enc2 >> 4)
      chr2 = ((enc2 & 15) << 4) | (enc3 >> 2)
      chr3 = ((enc3 & 3) << 6) | enc4
      if ol % 2 is 0
        output_ = chr1 << 8
        output += f(output_ | chr2)  unless enc3 is 64
        output_ = chr3 << 8  unless enc4 is 64
      else
        output = output + f(output_ | chr1)
        output_ = chr2 << 8  unless enc3 is 64
        output += f(output_ | chr3)  unless enc4 is 64
      ol += 3
    LZString.decompress output

  compressToUTF16: (input) ->
    return ""  unless input?
    output = ""
    i = undefined
    c = undefined
    current = undefined
    status = 0
    f = LZString._f
    input = LZString.compress(input)
    i = 0
    while i < input.length
      c = input.charCodeAt(i)
      switch status++
        when 0
          output += f((c >> 1) + 32)
          current = (c & 1) << 14
        when 1
          output += f((current + (c >> 2)) + 32)
          current = (c & 3) << 13
        when 2
          output += f((current + (c >> 3)) + 32)
          current = (c & 7) << 12
        when 3
          output += f((current + (c >> 4)) + 32)
          current = (c & 15) << 11
        when 4
          output += f((current + (c >> 5)) + 32)
          current = (c & 31) << 10
        when 5
          output += f((current + (c >> 6)) + 32)
          current = (c & 63) << 9
        when 6
          output += f((current + (c >> 7)) + 32)
          current = (c & 127) << 8
        when 7
          output += f((current + (c >> 8)) + 32)
          current = (c & 255) << 7
        when 8
          output += f((current + (c >> 9)) + 32)
          current = (c & 511) << 6
        when 9
          output += f((current + (c >> 10)) + 32)
          current = (c & 1023) << 5
        when 10
          output += f((current + (c >> 11)) + 32)
          current = (c & 2047) << 4
        when 11
          output += f((current + (c >> 12)) + 32)
          current = (c & 4095) << 3
        when 12
          output += f((current + (c >> 13)) + 32)
          current = (c & 8191) << 2
        when 13
          output += f((current + (c >> 14)) + 32)
          current = (c & 16383) << 1
        when 14
          output += f((current + (c >> 15)) + 32, (c & 32767) + 32)
          status = 0
      i++
    output + f(current + 32)

  decompressFromUTF16: (input) ->
    return ""  unless input?
    output = ""
    current = undefined
    c = undefined
    status = 0
    i = 0
    f = LZString._f
    while i < input.length
      c = input.charCodeAt(i) - 32
      switch status++
        when 0
          current = c << 1
        when 1
          output += f(current | (c >> 14))
          current = (c & 16383) << 2
        when 2
          output += f(current | (c >> 13))
          current = (c & 8191) << 3
        when 3
          output += f(current | (c >> 12))
          current = (c & 4095) << 4
        when 4
          output += f(current | (c >> 11))
          current = (c & 2047) << 5
        when 5
          output += f(current | (c >> 10))
          current = (c & 1023) << 6
        when 6
          output += f(current | (c >> 9))
          current = (c & 511) << 7
        when 7
          output += f(current | (c >> 8))
          current = (c & 255) << 8
        when 8
          output += f(current | (c >> 7))
          current = (c & 127) << 9
        when 9
          output += f(current | (c >> 6))
          current = (c & 63) << 10
        when 10
          output += f(current | (c >> 5))
          current = (c & 31) << 11
        when 11
          output += f(current | (c >> 4))
          current = (c & 15) << 12
        when 12
          output += f(current | (c >> 3))
          current = (c & 7) << 13
        when 13
          output += f(current | (c >> 2))
          current = (c & 3) << 14
        when 14
          output += f(current | (c >> 1))
          current = (c & 1) << 15
        when 15
          output += f(current | c)
          status = 0
      i++
    LZString.decompress output


#return output;
  compress: (uncompressed) ->
    return ""  unless uncompressed?
    i = undefined
    value = undefined
    context_dictionary = {}
    context_dictionaryToCreate = {}
    context_c = ""
    context_wc = ""
    context_w = ""
    context_enlargeIn = 2 # Compensate for the first entry which should not count
    context_dictSize = 3
    context_numBits = 2
    context_data_string = ""
    context_data_val = 0
    context_data_position = 0
    ii = undefined
    f = LZString._f
    ii = 0
    while ii < uncompressed.length
      context_c = uncompressed.charAt(ii)
      unless Object::hasOwnProperty.call(context_dictionary, context_c)
        context_dictionary[context_c] = context_dictSize++
        context_dictionaryToCreate[context_c] = true
      context_wc = context_w + context_c
      if Object::hasOwnProperty.call(context_dictionary, context_wc)
        context_w = context_wc
      else
        if Object::hasOwnProperty.call(context_dictionaryToCreate, context_w)
          if context_w.charCodeAt(0) < 256
            i = 0
            while i < context_numBits
              context_data_val = (context_data_val << 1)
              if context_data_position is 15
                context_data_position = 0
                context_data_string += f(context_data_val)
                context_data_val = 0
              else
                context_data_position++
              i++
            value = context_w.charCodeAt(0)
            i = 0
            while i < 8
              context_data_val = (context_data_val << 1) | (value & 1)
              if context_data_position is 15
                context_data_position = 0
                context_data_string += f(context_data_val)
                context_data_val = 0
              else
                context_data_position++
              value = value >> 1
              i++
          else
            value = 1
            i = 0
            while i < context_numBits
              context_data_val = (context_data_val << 1) | value
              if context_data_position is 15
                context_data_position = 0
                context_data_string += f(context_data_val)
                context_data_val = 0
              else
                context_data_position++
              value = 0
              i++
            value = context_w.charCodeAt(0)
            i = 0
            while i < 16
              context_data_val = (context_data_val << 1) | (value & 1)
              if context_data_position is 15
                context_data_position = 0
                context_data_string += f(context_data_val)
                context_data_val = 0
              else
                context_data_position++
              value = value >> 1
              i++
          context_enlargeIn--
          if context_enlargeIn is 0
            context_enlargeIn = Math.pow(2, context_numBits)
            context_numBits++
          delete context_dictionaryToCreate[context_w]
        else
          value = context_dictionary[context_w]
          i = 0
          while i < context_numBits
            context_data_val = (context_data_val << 1) | (value & 1)
            if context_data_position is 15
              context_data_position = 0
              context_data_string += f(context_data_val)
              context_data_val = 0
            else
              context_data_position++
            value = value >> 1
            i++
        context_enlargeIn--
        if context_enlargeIn is 0
          context_enlargeIn = Math.pow(2, context_numBits)
          context_numBits++

        # Add wc to the dictionary.
        context_dictionary[context_wc] = context_dictSize++
        context_w = String(context_c)
      ii += 1

    # Output the code for w.
    if context_w isnt ""
      if Object::hasOwnProperty.call(context_dictionaryToCreate, context_w)
        if context_w.charCodeAt(0) < 256
          i = 0
          while i < context_numBits
            context_data_val = (context_data_val << 1)
            if context_data_position is 15
              context_data_position = 0
              context_data_string += f(context_data_val)
              context_data_val = 0
            else
              context_data_position++
            i++
          value = context_w.charCodeAt(0)
          i = 0
          while i < 8
            context_data_val = (context_data_val << 1) | (value & 1)
            if context_data_position is 15
              context_data_position = 0
              context_data_string += f(context_data_val)
              context_data_val = 0
            else
              context_data_position++
            value = value >> 1
            i++
        else
          value = 1
          i = 0
          while i < context_numBits
            context_data_val = (context_data_val << 1) | value
            if context_data_position is 15
              context_data_position = 0
              context_data_string += f(context_data_val)
              context_data_val = 0
            else
              context_data_position++
            value = 0
            i++
          value = context_w.charCodeAt(0)
          i = 0
          while i < 16
            context_data_val = (context_data_val << 1) | (value & 1)
            if context_data_position is 15
              context_data_position = 0
              context_data_string += f(context_data_val)
              context_data_val = 0
            else
              context_data_position++
            value = value >> 1
            i++
        context_enlargeIn--
        if context_enlargeIn is 0
          context_enlargeIn = Math.pow(2, context_numBits)
          context_numBits++
        delete context_dictionaryToCreate[context_w]
      else
        value = context_dictionary[context_w]
        i = 0
        while i < context_numBits
          context_data_val = (context_data_val << 1) | (value & 1)
          if context_data_position is 15
            context_data_position = 0
            context_data_string += f(context_data_val)
            context_data_val = 0
          else
            context_data_position++
          value = value >> 1
          i++
      context_enlargeIn--
      if context_enlargeIn is 0
        context_enlargeIn = Math.pow(2, context_numBits)
        context_numBits++

    # Mark the end of the stream
    value = 2
    i = 0
    while i < context_numBits
      context_data_val = (context_data_val << 1) | (value & 1)
      if context_data_position is 15
        context_data_position = 0
        context_data_string += f(context_data_val)
        context_data_val = 0
      else
        context_data_position++
      value = value >> 1
      i++

    # Flush the last char
    loop
      context_data_val = (context_data_val << 1)
      if context_data_position is 15
        context_data_string += f(context_data_val)
        break
      else
        context_data_position++
    context_data_string

  decompress: (compressed) ->
    return ""  unless compressed?
    return null  if compressed is ""
    dictionary = []
    next = undefined
    enlargeIn = 4
    dictSize = 4
    numBits = 3
    entry = ""
    result = ""
    i = undefined
    w = undefined
    bits = undefined
    resb = undefined
    maxpower = undefined
    power = undefined
    c = undefined
    f = LZString._f
    data =
      string: compressed
      val: compressed.charCodeAt(0)
      position: 32768
      index: 1

    i = 0
    while i < 3
      dictionary[i] = i
      i += 1
    bits = 0
    maxpower = Math.pow(2, 2)
    power = 1
    until power is maxpower
      resb = data.val & data.position
      data.position >>= 1
      if data.position is 0
        data.position = 32768
        data.val = data.string.charCodeAt(data.index++)
      bits |= ((if resb > 0 then 1 else 0)) * power
      power <<= 1
    switch next = bits
      when 0
        bits = 0
        maxpower = Math.pow(2, 8)
        power = 1
        until power is maxpower
          resb = data.val & data.position
          data.position >>= 1
          if data.position is 0
            data.position = 32768
            data.val = data.string.charCodeAt(data.index++)
          bits |= ((if resb > 0 then 1 else 0)) * power
          power <<= 1
        c = f(bits)
      when 1
        bits = 0
        maxpower = Math.pow(2, 16)
        power = 1
        until power is maxpower
          resb = data.val & data.position
          data.position >>= 1
          if data.position is 0
            data.position = 32768
            data.val = data.string.charCodeAt(data.index++)
          bits |= ((if resb > 0 then 1 else 0)) * power
          power <<= 1
        c = f(bits)
      when 2
        return ""
    dictionary[3] = c
    w = result = c
    loop
      return ""  if data.index > data.string.length
      bits = 0
      maxpower = Math.pow(2, numBits)
      power = 1
      until power is maxpower
        resb = data.val & data.position
        data.position >>= 1
        if data.position is 0
          data.position = 32768
          data.val = data.string.charCodeAt(data.index++)
        bits |= ((if resb > 0 then 1 else 0)) * power
        power <<= 1
      switch c = bits
        when 0
          bits = 0
          maxpower = Math.pow(2, 8)
          power = 1
          until power is maxpower
            resb = data.val & data.position
            data.position >>= 1
            if data.position is 0
              data.position = 32768
              data.val = data.string.charCodeAt(data.index++)
            bits |= ((if resb > 0 then 1 else 0)) * power
            power <<= 1
          dictionary[dictSize++] = f(bits)
          c = dictSize - 1
          enlargeIn--
        when 1
          bits = 0
          maxpower = Math.pow(2, 16)
          power = 1
          until power is maxpower
            resb = data.val & data.position
            data.position >>= 1
            if data.position is 0
              data.position = 32768
              data.val = data.string.charCodeAt(data.index++)
            bits |= ((if resb > 0 then 1 else 0)) * power
            power <<= 1
          dictionary[dictSize++] = f(bits)
          c = dictSize - 1
          enlargeIn--
        when 2
          return result
      if enlargeIn is 0
        enlargeIn = Math.pow(2, numBits)
        numBits++
      if dictionary[c]
        entry = dictionary[c]
      else
        if c is dictSize
          entry = w + w.charAt(0)
        else
          return null
      result += entry

      # Add w+entry[0] to the dictionary.
      dictionary[dictSize++] = w + entry.charAt(0)
      enlargeIn--
      w = entry
      if enlargeIn is 0
        enlargeIn = Math.pow(2, numBits)
        numBits++
    return

#module.exports = LZString  if typeof module isnt "undefined" and module?
