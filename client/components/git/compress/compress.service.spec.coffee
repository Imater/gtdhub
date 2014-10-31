'use strict'

describe 'Git object', ->
  sampleText = """
    like world in world in the world world world"""
  testAmount = 5
  # load the controller's module
  beforeEach module('gitStorage')

  CompressService = undefined
  beforeEach inject (_CompressService_) ->
    CompressService = _CompressService_

  it 'exist task model', ->
    expect(CompressService).toBeDefined()

  it 'compress and decompress', ->
    compressService = new CompressService("Pako")
    t = Date.now()
    for [0..testAmount]
      compressed = compressService.compress(sampleText)
    decompressed = compressService.decompress(compressed)
    expect(decompressed).toBe sampleText

  it 'compress by LZString', ->
    compressService = new CompressService("LZString")
    t = Date.now()
    for [0..testAmount]
      compressed = compressService.compress(sampleText)
    decompressed = compressService.decompress(compressed)
    expect(decompressed).toBe sampleText

  it 'compress by GZip',  ->
    compressService = new CompressService("PakoGzip")
    t = Date.now()
    for [0..testAmount]
      compressed = compressService.compress(sampleText)
    decompressed = compressService.decompress(compressed)
    expect(decompressed).toBe sampleText
