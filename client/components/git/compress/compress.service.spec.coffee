'use strict'

describe 'Git object', ->
  sampleText = """
    my father best men in the world and world is big and nice like world in world
    """
  testAmount = 500
  # load the controller's module
  beforeEach module('gtdhubApp')

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
    console.info  "Pako", compressed.length, sampleText.length, Date.now() - t
    decompressed = compressService.decompress(compressed)
    expect(decompressed).toBe sampleText

  it 'compress by LZString', ->
    compressService = new CompressService("LZString")
    t = Date.now()
    for [0..testAmount]
      compressed = compressService.compress(sampleText)
    decompressed = compressService.decompress(compressed)
    console.info  "LZString", compressed.length, sampleText.length, Date.now() - t
    expect(decompressed).toBe sampleText

  it 'compress by GZip',  ->
    compressService = new CompressService("PakoGzip")
    t = Date.now()
    for [0..testAmount]
      compressed = compressService.compress(sampleText)
    decompressed = compressService.decompress(compressed)
    console.info  "Gzip", compressed.length, sampleText.length, Date.now() - t
    expect(decompressed).toBe sampleText
