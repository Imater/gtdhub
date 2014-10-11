'use strict'

describe 'Model SettingSync', ->

  # load the controller's module
  beforeEach module('gtdhubApp')

  SettingSyncModel = undefined
  beforeEach inject (_SettingSyncModel_) ->
    SettingSyncModel = _SettingSyncModel_

  it 'exist task model', ->
    expect(SettingSyncModel).toBeDefined()
    settingSyncModel = new SettingSyncModel
      title: "SettingSync"
      date: new Date();
    expect(settingSyncModel).toBeDefined()
    expect(settingSyncModel.get().title).toBe "SettingSync"
