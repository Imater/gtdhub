###*
Copyright 2010 Konstantin Plotnikov.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
###

#global module, require, window 
(->
  diffable = {}
  diffable.RollingHash = ->
    @primeBase = 257
    @primeMod = 1000000007
    @lastPower = 0
    @lastString = ""
    @lastHash = 0
    return

  diffable.RollingHash:: =
    
    ###*
    @private
    @param {Number} base
    @param {Number} power
    @param {Number} modulo
    ###
    moduloExp: (base, power, modulo) ->
      toReturn = 1
      i = undefined
      i = 0
      while i < power
        toReturn = (base * toReturn) % modulo
        i += 1
      toReturn

    
    ###*
    @param {String} toHash
    ###
    hash: (toHash) ->
      hash = 0
      toHashArray = toHash.split("")
      i = undefined
      len = toHashArray.length
      i = 0
      while i < len
        hash += (toHashArray[i].charCodeAt(0) * @moduloExp(@primeBase, len - 1 - i, @primeMod)) % @primeMod
        hash %= @primeMod
        i += 1
      @lastPower = @moduloExp(@primeBase, len - 1, @primeMod)
      @lastString = toHash
      @lastHash = hash
      hash

    
    ###*
    @param {String} toAdd
    ###
    nextHash: (toAdd) ->
      hash = @lastHash
      lsArray = @lastString.split("")
      hash -= (lsArray[0].charCodeAt(0) * @lastPower)
      hash = hash * @primeBase + toAdd.charCodeAt(0)
      hash %= @primeMod
      hash += @primeMod  if hash < 0
      lsArray.shift()
      lsArray.push toAdd
      @lastString = lsArray.join("")
      @lastHash = hash
      hash

  
  ###*
  @param {String} text
  @param {Number} offset
  ###
  diffable.Block = (text, offset) ->
    @text = text
    @offset = offset
    @nextBlock = null
    return

  diffable.Block:: =
    getText: ->
      @text

    getOffset: ->
      @offset

    
    ###*
    @param {diffable.Block} nextBlock
    ###
    setNextBlock: (nextBlock) ->
      @nextBlock = nextBlock
      return

    getNextBlock: ->
      @nextBlock

  
  ###*
  @param {String} originalText
  @param {Number} blockSize
  ###
  diffable.BlockText = (originalText, blockSize) ->
    @originalText = originalText
    @blockSize = blockSize
    @blocks = []
    i = undefined
    len = originalText.split("").length
    endIndex = undefined
    i = 0
    while i < len
      endIndex = (if i + blockSize >= len then len else i + blockSize)
      @blocks.push new diffable.Block(originalText.substring(i, endIndex), i)
      i += blockSize
    return

  diffable.BlockText:: =
    getBlocks: ->
      @blocks

    getOriginalText: ->
      @originalText

    getBlockSize: ->
      @blockSize

  diffable.Dictionary = ->
    @dictionary = {}
    @dictionaryText = null
    return

  diffable.Dictionary:: =
    put: (key, block) ->
      @dictionary[key] = []  unless @dictionary.hasOwnProperty(key)
      @dictionary[key].push block
      return

    
    ###*
    @param {diffable.BlockText} dictText
    @param {diffable.RollingHash} hasher
    ###
    populateDictionary: (dictText, hasher) ->
      @dictionary = {}
      @dictionaryText = dictText
      blocks = dictText.getBlocks()
      i = undefined
      len = undefined
      i = 0
      len = blocks.length

      while i < len
        @put hasher.hash(blocks[i].getText()), blocks[i]
        i += 1
      return

    
    ###*
    @param {Number} hash
    @param {Number} blockSize
    @param {String} target
    ###
    getMatch: (hash, blockSize, target) ->
      blocks = undefined
      i = undefined
      len = undefined
      dictText = undefined
      targetText = undefined
      currentPointer = undefined
      if @dictionary.hasOwnProperty(hash)
        blocks = @dictionary[hash]
        i = 0
        len = blocks.length

        while i < len
          if blocks[i].getText() is target.substring(0, blockSize)
            if @dictionaryText isnt null and blocks[i].getNextBlock() is null
              dictText = @dictionaryText.getOriginalText().substring(blocks[i].getOffset() + blockSize)
              targetText = target.substring(blockSize)
              return blocks[i]  if dictText.length is 0 or targetText.length is 0
              currentPointer = 0
              currentPointer += 1  while currentPointer < dictText.length and currentPointer < targetText.length and dictText[currentPointer] is targetText[currentPointer]
              return new diffable.Block(blocks[i].getText() + dictText.substring(0, currentPointer), blocks[i].getOffset())
            else if blocks[i].getNextBlock() isnt null
              return blocks[i]
            else
              return blocks[i]
          i += 1
        return null
      null

  
  ###*
  @param {diffable.RollingHash} hasher
  @param {diffable.Dictionary} target
  ###
  diffable.Vcdiff = (hasher, dictText) ->
    @hash = hasher
    @dictText = new diffable.Dictionary()
    @blockSize = 20
    @hash = new diffable.RollingHash()
    return

  diffable.Vcdiff:: =
    
    ###*
    @param {String} dict
    @param {String} target
    ###
    encode: (dict, target) ->
      return []  if dict is target
      diffString = []
      targetLength = undefined
      targetIndex = undefined
      currentHash = undefined
      addBuffer = ""
      match = undefined
      @dictText.populateDictionary new diffable.BlockText(dict, @blockSize), @hash
      targetLength = target.length
      targetIndex = 0
      currentHash = -1
      while targetIndex < targetLength
        if targetLength - targetIndex < @blockSize
          diffString.push addBuffer + target.substring(targetIndex, targetLength)
          break
        else
          if currentHash is -1
            currentHash = @hash.hash(target.substring(targetIndex, targetIndex + @blockSize))
          else
            currentHash = @hash.nextHash(target[targetIndex + (@blockSize - 1)])
            currentHash = @hash.hash(target.substring(0, targetIndex + @blockSize))  if currentHash < 0
          match = @dictText.getMatch(currentHash, @blockSize, target.substring(targetIndex))
          if match is null
            addBuffer += target[targetIndex]
            targetIndex += 1
          else
            if addBuffer.length > 0
              diffString.push addBuffer
              addBuffer = ""
            diffString.push match.getOffset()
            diffString.push match.getText().length
            targetIndex += match.getText().length
            currentHash = -1
      diffString

    
    ###*
    @param {Object} dict
    @param {Object} diff
    ###
    decode: (dict, diff) ->
      output = []
      i = undefined
      return dict  if diff.length is 0
      i = 0
      while i < diff.length
        if typeof diff[i] is "number"
          output.push dict.substring(diff[i], diff[i] + diff[i + 1])
          i += 1
        else output.push diff[i]  if typeof diff[i] is "string"
        i += 1
      output.join ""

  if typeof module is "undefined" or typeof require is "undefined"
    window.diffable = diffable
  else
    module.exports = diffable
  return
)()
