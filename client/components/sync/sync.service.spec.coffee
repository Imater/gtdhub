'use strict'

LAST_SYNC_TIME = 1413009570983

describe 'Service syncToServer should', ->

  # load the controller's module
  beforeEach module('gtdhubApp')

  SyncToServer = undefined
  beforeEach inject (_SyncToServer_) ->
    SyncToServer = _SyncToServer_

  it 'exist', ->
    expect(!!SyncToServer).toBe true
    syncToServer = new SyncToServer()
    expect(syncToServer.hello).toBe "hello"

  it 'have method SyncNow', ->
    syncToServer = new SyncToServer()
    expect(syncToServer.syncNow).toBeDefined()

  it 'have method get last sync time', ->
    syncToServer = new SyncToServer()
    syncToServer.lastSyncTime = ->
      LAST_SYNC_TIME
    expect(syncToServer.lastSyncTime()).toBe LAST_SYNC_TIME
    expect(syncToServer.syncNow()).toBe LAST_SYNC_TIME

  it 'have method get last sync time', ->
    syncToServer = new SyncToServer()
    syncToServer.lastSyncTime = ->
      888
    expect(syncToServer.lastSyncTime()).toBe 888
    expect(syncToServer.syncNow()).toBe 888

